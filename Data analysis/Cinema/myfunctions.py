import numpy as np
import pandas as pd

def clear_dollars(data, columns):
    for column in columns:
        data[column] = data[column].str.replace('$', '').astype(np.int64)
        