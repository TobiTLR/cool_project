import pandas as pd
import os

# Ensure the data directory exists
os.makedirs('data', exist_ok=True)

# File path
file_path = 'data/metadata.csv'

# Create a DataFrame with initial data
initial_data = pd.DataFrame({
    'ID': [1, 2],
    'Name': ['Alice', 'Bob'],
    'Age': [30, 25]
})

# Save the DataFrame to a CSV file
initial_data.to_csv(file_path, index=False)

# Read the CSV file into a DataFrame
data_read = pd.read_csv(file_path)

# New data to append
new_data = pd.DataFrame({
    'ID': [3],
    'Name': ['Charlie'],
    'Age': [35]
})

# Append new data to the DataFrame
data_appended = data_read.append(new_data, ignore_index=True)

# Save the updated DataFrame to the CSV file
data_appended.to_csv(file_path, index=False)

# Read the updated CSV file into a DataFrame
updated_data = pd.read_csv(file_path)

print(updated_data)