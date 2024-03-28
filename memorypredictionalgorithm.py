This algorithm uses the scikit-learn library to create a linear regression model that predicts computer memory usage based on system and user history. The data is loaded into a DataFrame and split into training and testing sets. The model is trained on the training data, and then used to predict memory usage on the test data. The mean absolute error (MAE) is calculated to evaluate the accuracy of the model. Finally, the model can be used to predict future memory usage by providing new values for system and user history.

It's worth noting that this is an example and depending on the complexity of the problem this algorithm might not work. Also, it's important to have a good and enough amount of data to train your model, otherwise, the model will not be accurate.

Please note that the data used in this example should be in the form of a CSV file with columns named "system_history", "user_history" and "memory_usage" and should be loaded into a pandas dataframe before running the algorithm.

import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split

# Load the data into a DataFrame
data = pd.read_csv('memory_usage.csv')

# Define the features and target
X = data[['system_history', 'user_history']]
y = data['memory_usage']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Create the linear regression model
model = LinearRegression()

# Train the model on the training data
model.fit(X_train, y_train)

# Predict the memory usage on the test data
y_pred = model.predict(X_test)

# Calculate the mean absolute error
mae = mean_absolute_error(y_test, y_pred)
print("Mean Absolute Error: ", mae)

# Predict future memory usage
future_system_history = [100, 200, 300]
future_user_history = [10, 20, 30]
future_memory_usage = model.predict([[future_system_history, future_user_history]])
print("Future Memory Usage: ", future_memory_usage)
