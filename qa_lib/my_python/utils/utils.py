from pathlib import Path

import logging
import time
import pywinctl as pwc

def select_file_by_search_file_explorer(title_file_explorer:str, file_name: str, path: str):
    import pyautogui

    home = Path.home()
    file_path = str(home / path / file_name)

    window = pwc.getWindowsWithTitle(title_file_explorer)
    win = window[0]
    win.activate()

    time.sleep(0.2)

    pyautogui.hotkey('ctrl', 'l')
    pyautogui.write(file_path, interval=0.05)
    pyautogui.press('enter')
    pyautogui.press('enter')

def directory_is_not_empty(path: str):
    try:
        p = Path(path)
        return  p.exists() and any(p.iterdir())
    except Exception as e:
        logging.error(f'Error to access the directory {path}. {e}')
        return False
