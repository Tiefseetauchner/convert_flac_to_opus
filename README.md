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

# This is awful. How can I make more of this?

You want to write *more* of these god awful scripts? Feel free! Make a fork and add your script in the same vein (like video conversion) or extend my script, and then make a pull request

# How do you make scripts like this?
I drink copius amounts of coffee!

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/tiefseetauchner)
