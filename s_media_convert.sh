#!/bin/bash
filename=${@//" "/"\ "}
filename=${filename//"("/"\("}
filename=${filename//")"/"\)"}
CMD="avprobe  -show_streams $filename 2>/dev/null"
echo $CMD
media_properties=$(eval "$CMD")

ifs_bkp=$IFS
get() {
	local stream=$1
	local prop=$2
	if [ "$stream" = "video" ]; then
		properties="$video_in_properties"
	else
		properties="$audio_in_properties"
	fi
	res=$(echo -e "$properties" | grep -i "$prop")
	echo "${res#*=}"
}

get_stream_properties() {
	local stream=$@
	local properties=$media_properties
	local is_stream
	local off=0
	while [ "$is_stream" = "" ];
	do
		res=${properties#*streams}
		res=${res%%[*}
		is_stream=$(echo "$res" | grep "codec_type=$stream")
		if [ "$is_stream" == "" ]; then
			off=$(($off + ${#res}))
			properties="${media_properties:off}"
		fi
	done
	echo "$res"
}

video_in_properties=$(get_stream_properties video)
audio_in_properties=$(get_stream_properties audio)

declare -A video_in_p
declare -A audio_in_p
video_in_p["codec_name"]=$(get video codec_name)
video_in_p["width"]=$(get video width)
video_in_p["height"]=$(get video height)
video_in_p["bitrate"]=$(get video bit_rate)
video_in_p["format"]=$(get video display_aspect_ratio)

audio_in_p["codec_name"]=$(get audio codec_name)
audio_in_p["sample_rate"]=$(get audio sample_rate)
audio_in_p["bitrate"]=$(get audio bit_rate)
echo "video codec name=${video_in_p["codec_name"]} width=${video_in_p["width"]} bitrate=${video_in_p["bitrate"]}"
echo "audio codec name=${audio_in_p["codec_name"]} sample_rate=${audio_in_p["sample_rate"]} bitrate=${audio_in_p["bitrate"]}"

## /usr/bin/avconv -y -i "/home/fpaut/Downloads/youtube/Khumba - Dessin animé complet en francais walt disney. Dessin anime francais.mp4" -f avi -r 29.97 -filter:v crop=iw:ih-58-62:0:58,scale=640:272 -vcodec libxvid -vtag XVID -aspect 2.35 -maxrate 1800k -b 1500k -qmin 3 -qmax 5 -bufsize 4096 -mbd 2 -bf 2 -trellis 1 -flags +aic -cmp 2 -subcmp 2 -g 300 -acodec libmp3lame -ar 48000 -ab 128k -ac 2 "/home/fpaut/Khumba - Dessin animé complet en francais walt disney. Dessin anime francais.avi"

## Global options (affect whole program instead of just one file:
## -loglevel loglevel  set libav* logging level
## -v loglevel         set libav* logging level
## -y                  overwrite output files
## -stats              print progress report during encoding
## -vol volume         change audio volume (256=normal)
##
## Advanced global options:
## -benchmark          add timings for benchmarking
## -timelimit limit    set max runtime in seconds
## -dump               dump each input packet
## -hex                when dumping packets, also dump the payload
## -vsync              video sync method
## -async              audio sync method
## -adrift_threshold threshold  audio drift threshold
## -copyts             copy timestamps
## -copytb             copy input stream time base when stream copying
## -dts_delta_threshold threshold  timestamp discontinuity delta threshold
## -xerror error       exit on error
## -filter_complex graph_description  create a complex filtergraph
## -cpuflags mask      set CPU flags mask
## -vdt n              discard threshold
## -deinterlace        this option is deprecated, use the yadif filter instead
## -vstats             dump video coding statistics to file
## -vstats_file file   dump video coding statistics to file
## -dc precision       intra_dc_precision
## -qphist             show QP histogram
## -isync              this option is deprecated and does nothing
##
## Per-file main options:
## -f fmt              force format
## -c codec            codec name
## -codec codec        codec name
## -pre preset         preset name
## -map_metadata outfile[,metadata]:infile[,metadata]  set metadata information of outfile from infile
## -t duration         record or transcode "duration" seconds of audio/video
## -fs limit_size      set the limit file size in bytes
## -ss time_off        set the start time offset
## -metadata string=string  add metadata
## -target type        specify target file type ("vcd", "svcd", "dvd", "dv", "dv50", "pal-vcd", "ntsc-svcd", ...)
## -frames number      set the number of frames to record
## -filter filter_list  set stream filterchain
##
## Advanced per-file options:
## -map [-]input_file_id[:stream_specifier][,sync_file_id[:stream_s  set input stream mapping
## -map_chapters input_file_index  set chapters mapping
## -itsoffset time_off  set the input ts offset
## -itsscale scale     set the input ts scale
## -dframes number     set the number of data frames to record
## -re                 read input at native frame rate
## -shortest           finish encoding within shortest input
## -copyinkf           copy initial non-keyframes
## -tag fourcc/tag     force codec tag/fourcc
## -q q                use fixed quality scale (VBR)
## -qscale q           use fixed quality scale (VBR)
## -attach filename    add an attachment to the output file
## -dump_attachment filename  extract an attachment into a file
## -muxdelay seconds   set the maximum demux-decode delay
## -muxpreload seconds  set the initial demux-decode delay
## -bsf bitstream_filters  A comma-separated list of bitstream filters
## -dcodec codec       force data codec ('copy' to copy stream)
##
## Video options:
## -vframes number     set the number of video frames to record
## -r rate             set frame rate (Hz value, fraction or abbreviation)
## -s size             set frame size (WxH or abbreviation)
## -aspect aspect      set aspect ratio (4:3, 16:9 or 1.3333, 1.7777)
## -vn                 disable video
## -vcodec codec       force video codec ('copy' to copy stream)
## -pass n             select the pass number (1 or 2)
## -vf filter list     video filters
##
## Advanced Video options:
## -pix_fmt format     set pixel format
## -vdt n              discard threshold
## -rc_override override  rate control override for specific intervals
## -passlogfile prefix  select two pass log file name prefix
## -deinterlace        this option is deprecated, use the yadif filter instead
## -vstats             dump video coding statistics to file
## -vstats_file file   dump video coding statistics to file
## -intra_matrix matrix  specify intra matrix coeffs
## -inter_matrix matrix  specify inter matrix coeffs
## -top                top=1/bottom=0/auto=-1 field first
## -dc precision       intra_dc_precision
## -vtag fourcc/tag    force video tag/fourcc
## -qphist             show QP histogram
## -force_fps          force the selected framerate, disable the best supported framerate selection
## -streamid streamIndex:value  set the value of an outfile streamid
## -force_key_frames timestamps  force key frames at specified timestamps
##
## Audio options:
## -aframes number     set the number of audio frames to record
## -aq quality         set audio quality (codec-specific)
## -ar rate            set audio sampling rate (in Hz)
## -ac channels        set number of audio channels
## -an                 disable audio
## -acodec codec       force audio codec ('copy' to copy stream)
## -vol volume         change audio volume (256=normal)
## -af filter list     audio filters
##
## Advanced Audio options:
## -atag fourcc/tag    force audio tag/fourcc
## -sample_fmt format  set sample format
## -channel_layout layout  set channel layout
##
## Subtitle options:
## -sn                 disable subtitle
## -scodec codec       force subtitle codec ('copy' to copy stream)
## -stag fourcc/tag    force subtitle tag/fourcc
##

IFS=$ifs_bkp

