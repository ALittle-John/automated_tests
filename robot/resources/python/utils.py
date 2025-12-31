from pathlib import Path

import time
import logging
import os

def select_file_by_search_file_explorer(file_name, path):
    import pyautogui
    base_path = Path(f"/root/{path}")
    full_path = os.path.join(base_path, file_name)

    if not os.path.isfile(full_path):
        logging.error(f"File not found: {full_path}")
        return None
    logging.info(f'Starting to search file: {file_name}')

    pyautogui.hotkey("ctrl", "f")
    pyautogui.write(file_name, interval=0.2)

    pyautogui.press("enter")

def list_folders_content(path):
    if os.path.exists(path):
        contents = os.listdir(path)
    else:
        logging.error(f"Error: The directory '{path}' does not exist.")
        contents = []

    return  contents
