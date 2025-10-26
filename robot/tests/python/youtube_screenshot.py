import _setup
from resources.python.utils_web import SetupBrowser, WebElementInteractions

browser = SetupBrowser.open_browser(browser_name='Chrome')
SetupBrowser.search_website(browser=browser, url='https://www.youtube.com/')
WebElementInteractions.prove_element_present(browser=browser, locator_type='id', locator_value='logo')
