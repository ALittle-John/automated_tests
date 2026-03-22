from .browser_automation import *

# open_browser = SetupBrowser.open_browser
# shut_down_browser = SetupBrowser.shut_down_browser
# search_website = SetupBrowser.search_website

# get_web_element = WebElementInteractions.get_web_element
# get_web_elements = WebElementInteractions.get_web_elements
# submit_text = WebElementInteractions.submit_text
# click_enter_video = WebElementInteractions.click_enter_video

# __all__ = [
#     "search_website",
#     "open_browser",
#     "get_web_element",
#     "get_web_elements",
#     "submit_text",
#     "click_enter_video",
# ]

# ---------------------------------------
# Robot Framework uses a Procedural Style
# Ex:

# from .utils_web import SetupBrowser, WebElementInteractions

# _browser = SetupBrowser('chrome')
# _actions = WebElementInteractions(_browser)

# def search_website(url): return _browser.search_website(url)
# def get_web_element(locator_type, locator_value): return _actions.get_web_element(locator_type, locator_value)
# def submit_text(el, txt): return _actions.submit_text(el, txt)

# Using this I don't need to use "browser.search_website(url='XXXX')"
# Just "search_website(url='XXXX')"
# ---------------------------------------
