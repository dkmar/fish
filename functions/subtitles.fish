function subtitles
   open -a AnyBar
   and anybar white

   set fname (path basename -E $argv)
   # get the audio
   set fp (echo "/tmp/$fname.wav" | tr ' ' '_')
   ffmpeg -loglevel error -i $argv -vn -acodec pcm_s16le -ar 16000 -ac 1 $fp

   # transcribe
   and anybar yellow
   whisperkit-cli transcribe --language en \
      --model-path /Users/dkmar/Library/Containers/com.argmax.whisperkit.WhisperAX/Data/Documents/huggingface/models/argmaxinc/whisperkit-coreml/openai_whisper-large-v3-v20240930_turbo \
      --audio-path $argv \
      --skip-special-tokens --report \
      -- > /dev/null
   and rm "$fname.json"
   and rm "$fp"

   anybar quit
end
