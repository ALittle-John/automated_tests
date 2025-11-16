from selenium import webdriver
from selenium.webdriver import Keys, ActionChains
from selenium.webdriver.common.by import By
import time

from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.edge.service import Service as EdgeService
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.firefox import GeckoDriverManager

try:
    from python import _setup
    browser = _setup.browser
except ImportError:
    browser = None

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
        self.browser_name = browser_name.lower()
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

    def get_web_element(self, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_element = self.browser.find_element(locator_map[locator_type_upper], locator_value)

        return web_element

    def get_web_elements(self, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_elements = self.browser.find_elements(locator_map[locator_type_upper], locator_value)

        return web_elements

    def submit_text(self, web_element, text: str):
        web_element.send_keys(text)
        self.actions.key_down(Keys.ENTER).key_up(Keys.ENTER).perform()
        time.sleep(30)

    def click_enter_video(self, video_title: str):
        video_locator = f"//a[@id='video-title']//*[contains(., {video_title})]"

        video = self.browser.find_element(locator_map['XPATH'], video_locator)
        is_video_visible = video.is_displayed()
        assert is_video_visible == True
        video.click()
