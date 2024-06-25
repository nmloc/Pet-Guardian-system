import sys
import pickle
import pandas as pd
from datetime import datetime
from sklearn.preprocessing import OneHotEncoder
import numpy as np

def predict(model_path, future_periods):
    # Load the model
    with open(model_path, 'rb') as f:
        model = pickle.load(f)
    
    # Preprocess input
    future_dates = pd.date_range(start=datetime.now() + pd.DateOffset(months=1), periods=future_periods, freq='M')
    future_categories = [date.strftime('%Y-%m') for date in future_dates]

    reshaped = np.array(future_categories).reshape(-1, 1)
    one_hot_encoder = OneHotEncoder(categories=[future_categories])
    encoded_categories = one_hot_encoder.fit_transform(reshaped)

    # Make predictions
    prediction = model.predict(encoded_categories)

    return prediction

if __name__ == '__main__':
    model_path = sys.argv[1]
    future_periods = int(sys.argv[2])
    result = predict(model_path, future_periods)
    print(result)