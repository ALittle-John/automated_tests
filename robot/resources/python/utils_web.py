from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.edge.service import Service as EdgeService
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.firefox import GeckoDriverManager

from selenium.webdriver.common.by import By

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
    @staticmethod
    def open_browser(browser_name: str):
        browser_name = browser_name.lower()
        if browser_name == "chrome":
            browser = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
        elif browser_name == "firefox":
            browser = webdriver.Firefox(service=FirefoxService(GeckoDriverManager().install()))
        elif browser_name == "edge":
            browser = webdriver.Edge(service=EdgeService(EdgeChromiumDriverManager().install()))
        else:
            raise ValueError(f"Unsupported browser: {browser_name}")
        browser.maximize_window()

        return browser

    @staticmethod
    def shut_down_browser(browser: webdriver):
        browser.quit()

    @staticmethod
    def search_website(browser: webdriver, url: str):
        browser.get(url)

class WebElementInteractions:
    # Possible non-use of most functions in robot resources
    @staticmethod
    def prove_element_present(browser: webdriver, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_element = browser.find_element(locator_map[locator_type_upper], locator_value)

        return web_element

    @staticmethod
    def prove_elements_present(browser: webdriver, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_elements = browser.find_elements(locator_map[locator_type_upper], locator_value)

        return web_elements

    # def search_text(browser: webdriver, web_element: object, text: any):

