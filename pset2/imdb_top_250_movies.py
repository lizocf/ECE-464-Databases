import pandas as pd
from bs4 import BeautifulSoup
from selenium import webdriver

driver = webdriver.Chrome()

driver.get('https://www.imdb.com/chart/top/?ref_=chtmvm_ql_3') # landing page to visit

# Object is “results”, brackets make the object an empty list.
# We will be storing our data here.
titles = []
dates = []
runtimes = []
ratings = []

# Add the page source to the variable `content`.
content = driver.page_source
# Load the contents of the page, its source, into BeautifulSoup 
# class, which analyzes the HTML as a nested data structure and allows to select
# its elements by using various selectors.
soup = BeautifulSoup(content, 'html.parser')

for a in soup.find_all(attrs={'class': 'ipc-metadata-list-summary-item'}):
    title = a.find('h3')
    if title not in titles:
        titles.append(title.text)

for a in soup.find_all(attrs={'class': 'sc-b0691f29-7 hrgukm cli-title-metadata'}):
    date = a.find('span')
    runtime = date.find_next('span')
    rating = runtime.find_next('span')
    if date not in dates:
        dates.append(date.text)
    if runtime not in runtimes:
        runtimes.append(runtime.text)
    if rating not in ratings:
        ratings.append(rating.text)

series1 = pd.Series(titles, name='Movie Titles')
series2 = pd.Series(dates, name='Dates')
series3 = pd.Series(runtimes, name='Runtimes')
series4 = pd.Series(ratings, name='Ratings')

breakpoint()

df = pd.DataFrame({'Titles': series1, 'Dates': series2, 'Runtimes': series3, 'Ratings': series4})
df.to_csv('top250.csv', index=False, encoding='utf-8')

# <div class="sc-b0691f29-7 hrgukm cli-title-metadata"><span class="sc-b0691f29-8 ilsLEX cli-title-metadata-item">1994</span><span class="sc-b0691f29-8 ilsLEX cli-title-metadata-item">2h 22m</span><span class="sc-b0691f29-8 ilsLEX cli-title-metadata-item">R</span></div>