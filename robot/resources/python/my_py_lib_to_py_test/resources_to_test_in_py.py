"""
My own lib to use in test whith pure python.
"""
import logging
import time
import os
from pathlib import Path
from selenium.common.exceptions import *
from PIL import ImageGrab

from selenium import webdriver
from selenium.webdriver import Keys, ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.edge.service import Service as EdgeService
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.firefox import GeckoDriverManager

locator_map = {
    "ID": By.ID,
    "CLASS_NAME": By.CLASS_NAME,
    "LINK_TEXT": By.LINK_TEXT,
    "NAME": By.NAME,
    "TAG_NAME": By.TAG_NAME,
    "PARTIAL_LINK_TEXT": By.PARTIAL_LINK_TEXT,
    "XPATH": By.XPATH,
    "CSS_SELECTOR": By.CSS_SELECTOR
}

class SetupBrowser:
    # Possible non-use in robot resources
    def __init__(self, browser_name: str):
        self.browser_name:str = browser_name.lower()
        self.browser = None
        # "Self" loads the content into the rest of the class. When used before a variable, it can be accessed by other methods within the class.

    def open_browser(self):
        if self.browser is not None:
            return self.browser

        if self.browser_name == "chrome":
            self.browser = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
        elif self.browser_name == "firefox":
            self.browser = webdriver.Firefox(service=FirefoxService(GeckoDriverManager().install()))
        elif self.browser_name == "edge":
            self.browser = webdriver.Edge(service=EdgeService(EdgeChromiumDriverManager().install()))
        else:
            raise ValueError(f"Unsupported browser: {self.browser_name}")
        self.browser.maximize_window()
        self.browser.implicitly_wait(0.5)

        return self.browser

    def shut_down_browser(self):
        if self.browser is not None:
            self.browser.quit()
            self.browser = None

    def search_website(self, url: str):
        self.browser.get(url)

class WebElementInteractions:
    # Possible non-use of most functions in robot resources
    def __init__(self, driver):
        self.browser = driver
        self.actions = ActionChains(self.browser)

    def custom_find_element(
            self,
            locator_type: str,
            locator_value: str,
            custom_alert_error_msg: Optional[str] = None,
            custom_msg_level: Optional[str] = None,
            time: Optional[int] = 12,
        ):
        locator_type_upper = locator_type.upper()
        try:
            element: WebElement = WebDriverWait(self.browser, time).until(
                EC.visibility_of_element_located((locator_map[locator_type_upper], locator_value))
            )
            return element
        except TimeoutException:
            default_msg = f"Target element was not visible in {time} seconds: {locator_value}"
            msg = custom_alert_error_msg or default_msg
            if custom_msg_level:
                level = custom_msg_level.lower()
            else:
                level = "error"
            getattr(logging, level)(msg)
            return None

        except Exception as e:
            default_msg = f"Other exception while waiting for element {locator_value}: {e}"
            msg = custom_alert_error_msg or default_msg
            if custom_msg_level:
                level = custom_msg_level.lower()
            else:
                level = "error"
            getattr(logging, level)(msg)
            return None

    def get_web_element(self, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_element:WebElement = self.browser.find_element(locator_map[locator_type_upper], locator_value)

        return web_element

    def get_web_elements(self, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_elements:WebElement = self.browser.find_elements(locator_map[locator_type_upper], locator_value)

        return web_elements

    def submit_text(self, input_web_element, text: str):
        input_web_element.send_keys(text)
        self.actions.key_down(Keys.ENTER).key_up(Keys.ENTER).perform()

    def click_enter_video(self, video_locator: str):
        try:
            video:WebElement = self.browser.find_element(locator_map['XPATH'], video_locator)
        except NoSuchElementException:
            return logging.error(f"Unable to locate the element: {video_locator}")

        self.browser.execute_script("arguments[0].scrollIntoView(true);", video)
        self.browser.execute_script("window.scrollBy(0, -100);")

        video.click()

    def skip_video_if_visible(self):
        ad_xpath: str = "//div[@class= 'ytp-ad-player-overlay-layout']"
        skip_ad_xpath: str = "//button[contains(@class, 'ytp-skip-ad-button')]"

        res = self.custom_find_element(locator_type='xpath', locator_value=ad_xpath, time=3, custom_msg_level='info')
        if res:
            logging.info('Ad displayed.')

            res_button = self.custom_find_element(
                locator_type='xpath',
                locator_value=skip_ad_xpath,
                time=16,
                custom_alert_error_msg="The ad skip button didn't appear.",
                custom_msg_level="info"
                )
            if res_button:
                res_button.click()
                logging.info('Ad skiped.')
                time.sleep(3)

    def stop_video_at(self, targget_time: int):
        """
        targget_time: seconds
        """
        video = self.custom_find_element(locator_type="tag_name", locator_value="video")
        self.browser.execute_script("arguments[0].currentTime = arguments[1];", video, targget_time)
        self.browser.execute_script("arguments[0].pause();", video)

    def take_screenshot(self):
        screenshot_dir = Path("robot/tests/python/screenshots")

        if not screenshot_dir.exists():
            os.makedirs(screenshot_dir)

        screenshot_path = screenshot_dir / "yt_test.png"

        screenshot = ImageGrab.grab()
        screenshot.save(screenshot_path)
        screenshot.close()
