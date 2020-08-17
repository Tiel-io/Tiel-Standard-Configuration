# Reddit Wallpaper Downloader
This simple Python program automatically downloads wallpapers from a chosen subreddit. This is an improved version of the [reddit-wallpaper-downloader](https://github.com/mrsorensen/reddit-wallpaper-downloader) created by [MrSorensen](https://github.com/mrsorensen).

This program will scan for the most-upvoted images from a given subreddit and automatically download them to the user's computer if they are suitable for use as wallpapers. To be considered suitable for use as a wallpaper, an image must be at least the same resolution as the user's highest-resolution display. Additionally, an image must be of `.png`, `.jpeg`, or `.jpg` format and be landscape-oriented.

## Usage
```
python get-walls.py <subreddit> <directory> <target> <limit> <timeout>
```
The parameters of this program are as follows:
- `subreddit`: the name of the subreddit to try and download images from.
- `directory`: the directory where downloaded images should be stored. They will be stored here in a folder named per the `subreddit` variable.
- `target`: the desired number of images to download; the program will stop early once it has found this many.
- `limit`: the total number of images to spend time sifting through.
- `timeout`: the total amount of time each image is given to finish downloading before it is skipped and another is tried.

For example, this will look through at most `500` images from the `earthporn` subreddit and save them to the `~/Pictures/Wallpapers/Reddit` directory. It will stop early once it has downloaded `10` images. Each image will be given `1` second to finish downloading.
```
python get-walls.py earthporn ~/Pictures/Wallpapers/Reddit/ 10 500 1
```
