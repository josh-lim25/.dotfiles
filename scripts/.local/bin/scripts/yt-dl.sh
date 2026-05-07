# https://www.reddit.com/r/commandline/comments/sutogk/whats_your_favorite_shell_one_liner/
# I am not sure if this counts, but both are technically one-liners:
#
# # Videos
# youtube-dl \
#     --format bestvideo+bestaudio										   \
#     --merge-output-format "$YT_ONESHOT_OUTPUT_FORMAT"					   \
#     --add-metadata 														   \
#     --keep-video														   \
#     --ignore-errors														   \
#     "$YT_ONESHOT_URL"													   \
#     --output "$YT/$YT_ONESHOT_PATH/%(upload_date)s-%(title)s.%(ext)s"
#
# and
#
# # Audio
# youtube-dl \
#     --format bestaudio													   \
#     --add-metadata 														   \
#     --extract-audio														   \
#     --ignore-errors														   \
#     "$YT_ONESHOT_URL"													   \
#     --output "$YT/$YT_ONESHOT_PATH/%(upload_date)s-%(title)s.%(ext)s"
#
# Copied them from my "yt-oneshot" shell script. Does what you expect. It says:
#
#     What's the URL?
#
#     What folder do you want it in?
#
#     [a]udio or [v]ideo? 
