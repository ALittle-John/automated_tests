from robot.resources.python.my_py_lib_to_py_test import *
from robot.resources.python.my_py_lib_to_py_test import SetupBrowser, WebElementInteractions
import robot.resources.python.my_py_lib_to_py_test._setup as setup

video_targget = '3-HOUR STUDY WITH ME Pomodoro 25/5 [with Rain Sounds] No Music | At Nightfall with City View'
# video_targget = '3-HOUR STUDY WITjbufbifewbwwith Rain Sounds] No Music | At Nightfall with City View'
video_locator = f"//a[@id='video-title']//*[contains(., '{video_targget}')]"

browser_manager = SetupBrowser(browser_name='Chrome')
driver = browser_manager.open_browser()

actions = WebElementInteractions(driver=driver)

browser_manager.search_website(url='https://www.youtube.com/')
actions.get_web_element(locator_type='id', locator_value='logo')
search_yt_input = actions.get_web_element(locator_type='name', locator_value='search_query')
actions.submit_text(input_web_element=search_yt_input, text=video_targget)
actions.custom_find_element(locator_type='xpath', locator_value=video_locator)
actions.click_enter_video(video_locator=video_locator)
actions.custom_find_element(locator_type='tag_name', locator_value='video')
actions.skip_video_if_visible()
actions.stop_video_at(targget_time=280)
actions.take_screenshot()
