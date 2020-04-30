import pandas as pd

def clear_dollars(df, columns):
    """Takes columns of a specified DataFrame and for each of them deletes $ symbols and converts data into int"""
    for column in columns:
        df[column] = df[column].str.replace('$', '').astype('int64')
    return df[columns]

def split_column(df, column, new_column_prefix, pat):
    """Splits a column
    
    Parameters
    ----------
    df : pd.DataFrame
        Pandas DataFrame
    column : str
        Name of a column to split
    new_column_prefix : str
        Text which will be used as a prefix for every new column's name
    pat : str
        Delimiter to split on
        
    Returns
    -------
    pd.DataFrame
        A copy of original DataFrame with new columns split from the inputed
    """
    df = df.copy().dropna(subset=[column])
    split_col = df[column].str.split(pat, expand=True)
    return df.assign(
        **{
            f"{new_column_prefix}_{x+1}": split_col.iloc[:, x].str.strip()
            for x in range(split_col.shape[1])
        }
    )

def find_best(df, columns_to_save, column_prefix, n = 3):
    """Finds n max in each of columns_to_save.
    
    Function specifically searches for columns produced by a split_column function, takes them one by one and renames
    by deleting counters, adds columns_to_save and creates multiple DataFrames saving them into a dictionary.
    Those frames are concatenated and data is grouped by the values of previously splited column to get averages.
    
    Parameters
    ----------
    df : pd.DataFrame
        Pandas DataFrame
    columns_to_save : str
        List of columns from df you plan to get largest in
    column_prefix : str
        Prefix to find columns produced by 
    n : int (optional)
        How many rows to keep (default is top 3)

    Returns
    -------
    pd.DataFrame
        Displays a df for every column to find n largest in.
    """
    names_for_dfs = [col for col in df.columns if f"{column_prefix}_" in col]
    dfs = {
        name : df.loc[:, [f"{name}", *columns_to_save]].copy().
        dropna(subset=[f"{name}"]).
        rename(columns = {f"{name}" : column_prefix})
        for name in names_for_dfs
        }
    concat = pd.concat(dfs.values()).groupby(column_prefix)[columns_to_save].mean()
    for column in columns_to_save:
        display(concat.nlargest(n, column).reset_index())
    return

