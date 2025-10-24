from selenium import webdriver
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
    def open_browser(self, browser_name: str):
        browser_name = browser_name.lower()
        if browser_name == "chrome":
            browser = webdriver.Chrome()
        elif browser_name == "firefox":
            browser = webdriver.Firefox()
        elif browser_name == "edge":
            browser = webdriver.Edge()
        else:
            raise ValueError(f"Unsupported browser: {browser_name}")
        browser.maximize_window()

        return browser

    def shut_down_browser(self, browser: webdriver):
        browser.quit()

    def search_website(self, browser: webdriver, url: str):
        browser.get(url)

class WebElementInteractions:
    # Possible non-use of most functions in robot resources
    def prove_element_present(self, browser: webdriver, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_element = browser.find_element(locator_map[locator_type_upper], locator_value)

        return web_element

    def prove_elements_present(self, browser: webdriver, locator_type: str, locator_value: str):
        locator_type_upper = locator_type.upper()
        web_elements = browser.find_elements(locator_map[locator_type_upper], locator_value)

        return web_elements

    # def search_text(self, browser: webdriver, web_element: object, text: any):

