import time

from app import app


@app.task()
def process_numbers(numbers: list[int]) -> int:
    time.sleep(10)
    return sum(numbers)
