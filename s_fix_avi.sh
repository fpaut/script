#! /bin/bash
MOVIE_FILE=$@
OUTPUT=fixed_$MOVIE_FILE

# Available Audio codecs:
#    copy     - frame copy, without re-encoding (useful for AC3)
#    pcm      - uncompressed PCM audio
#    mp3lame  - cbr/abr/vbr MP3 using libmp3lame
#    lavc     - FFmpeg audio encoder (MP2, AC3, ...)
AUDIO_ENCODER=pcm

# Available video codecs:
#    copy     - frame copy, without re-encoding. Doesn't work with filters.
#    frameno  - special audio-only file for 3-pass encoding, see DOCS.
#    raw      - uncompressed video. Use fourcc option to set format explicitly.
#    nuv      - nuppel video
#    lavc     - libavcodec codecs - best quality!
#    xvid     - XviD encoding
#    x264     - H.264 encoding
VIDEO_ENCODER=x264 

echo 'Input file is '$MOVIE_FILE
echo 'Output file is '$OUTPUT
CMD="mencoder $MOVIE_FILE   -oac $AUDIO_ENCODER -ovc $VIDEO_ENCODER -o $OUTPUT"
echo $CMD; echo
eval "$CMD"
echo; echo "Command was:"; echo $CMD; echo

#mencoder $MOVIE_FILE  -forceidx -oac pcm -ovc copy -o $OUTPUT
