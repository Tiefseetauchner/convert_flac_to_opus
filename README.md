# convert_flac_to_opus
A shell script with a misleading name (it doesn't only do flac) that converts files to opus using ffmpeg

```
Convert audio files in directory to opus streams while maintaining metadata
Finds files recursively
usage: convert_flac_to_opus.sh [options]

-e list   Extensions to convert as comma seperated list
          Default: .flac
-d dir    Directory to search
          Default: .
-t num    Number of ffmpeg processes started concurrently
          Default: 1
-r        Removes old files after conversion
-y        Skip verification
-h        Show this help
```

# extract_lyrics
Extract UNSYNCEDLYRICS metadata from audio files and save them as txt files in the same location as the audio file.

```
usage: extract_lyrics.sh [options]

-d dir    Directory containing the music files
-t list   File types as a comma-separated list, e.g., mp3,flac,opus
-v        Verbose mode (optional)
-h        Show this help"
```

# This is awful. How can I make more of this?

You want to write *more* of these god awful scripts? Feel free! Make a fork and add your script in the same vein (like video conversion) or extend my script, and then make a pull request

# How do you make scripts like this?
I drink copius amounts of coffee!

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/tiefseetauchner)
