#!/usr/bin/env python3

# Imports.
import os
from os.path import expanduser
import sys
import requests
import urllib
from PIL import ImageFile
from screeninfo import get_monitors
from timeout import timeout

# Configuration.
subreddit = sys.argv[1]
directory = sys.argv[2]
target = int(sys.argv[3])
limit = int(sys.argv[4])
time_limit = int(sys.argv[5])
user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0'

# Determine the resolution we ought to target.
min_width = 0
min_height = 0
for m in get_monitors():
    if m.width > min_width:
        min_width = m.width
    if m.height > min_height:
        min_height = m.height

# Constants.
DARK = '\033[1;30m'
RED = '\033[1;31m'
GREEN = '\033[1;32m'
ORANGE = '\033[1;33m'
PURPLE = '\033[1;35m'
NC = '\033[0m'

# Creates the download directory if needed.
def prepareDirectory(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)
        print('* created wallpaper directory: {}'.format(directory))
    else:
        path, dirs, files = next(os.walk(directory))
        file_count = len(files)
        print('* found existing wallpaper directory: {} with {} files'.format(directory, file_count))
        if file_count >= target:
            print('* we already have enough images of the targeted sort; skipping further downloads!')
            sys.exit()

# Create the download directory.
directory = expanduser(directory)
directory = os.path.join(directory, subreddit)
prepareDirectory(directory)

# Checks whether or not our URL is an image.
def isImg(URL):
    if URL.endswith(('.png', '.jpeg', '.jpg')):
        return True
    else: return False

# Returns a list of posts from a subreddit.
def getPosts(subreddit, loops, after):
    allPosts = []
    i = 0
    while i < loops:
        URL = 'https://reddit.com/r/{}/top/.json?t=all&limit={}&after={}'.format(subreddit, jsonLimit, after)
        posts = requests.get(URL, headers = {'User-Agent':user_agent}).json()
        for post in posts['data']['children']:
            url = post['data']['url']
            if isImg(url):
                allPosts.append(url)
        after = posts['data']['after']
        i += 1
    return allPosts

# Returns false if image from URL does not have high enough resolution.
# Returns false if our URL image is not in landscape orientation.
# Returns false if there is an error accessing the URL.
def isPotentialWallpaper(URL, min_width, min_height):
    try:
        file = urllib.request.urlopen(URL)
        size = file.headers.get("content-length")
        if size: size = int(size)
        p = ImageFile.Parser()
        while 1:
            data = file.read(1024)
            if not data:
                break
            p.feed(data)
            if p.image:
                if p.image.size[0] >= min_width and p.image.size[1] >= min_height:
                    return p.image.size[0] >= p.image.size[1]
                    break
                else:
                    return False
                    break
        file.close()
        return False
    except:
        return False

# Returns true if the image from our URL is already downloaded.
def alreadyDownloaded(URL):
    imgName = os.path.basename(URL)
    localFilePath = os.path.join(directory, imgName)
    if(os.path.isfile(localFilePath)):
        return True
    else: return False

# Downloads our image and Returns true if stored locally.
@timeout(time_limit)
def storeImg(URL):
    if urllib.request.urlretrieve(URL, os.path.join(directory, os.path.basename(URL))):
        return True
    else: return False

# Retrieve posts.
print(GREEN + '* retrieving post URLs ...' + NC)
after = ''
jsonLimit = 100
loops = max(1, limit / 100)
posts = getPosts(subreddit, loops, after)
index = 1
downloadCount = 0
print(GREEN + '* post URLs retrieved.' + NC)

# Print a debug message.
print(DARK + '--------------------------------------------' + NC)
print(PURPLE + 'Downloading images to:  ' + ORANGE + directory + NC)
print(PURPLE + 'From /r/:               ' + ORANGE + subreddit + NC)
print(PURPLE + 'Minimum resolution:     ' + ORANGE + str(min_width) + 'x' + str(min_height) + NC)
print(PURPLE + 'Maximum time (seconds): ' + ORANGE + str(len(posts) * time_limit) + NC)
print(DARK + '--------------------------------------------' + NC)

# Loop through all posts.
for post in posts:
    if downloadCount >= target:
        print(GREEN + '* download target reached!' + NC)
        break

    if not isPotentialWallpaper(post, min_width, min_height):
        print(RED + '* {}) skipping unsuitable wallpaper image.'.format(index) + NC)
        index += 1
        continue

    elif alreadyDownloaded(post):
        print(RED + '* {}) skipping locally-present image.'.format(index) + NC)
        index += 1

        continue

    else:
        try:
            if storeImg(post):
                print(GREEN + '* {}) downloaded {}!'.format(index, os.path.basename(post)) + NC)
                downloadCount += 1
                index += 1
            else:
                print(RED + '* unexcepted error with image download.' + NC)
                index += 1
        except:
            print(RED + '* {}) skipping an image which took too long to download.'.format(index) + NC)
            index += 1
print(ORANGE + '* {}'.format(downloadCount) + PURPLE + ' images were downloaded to ' + ORANGE + '{}' + PURPLE + '.'.format(directory) + NC)
