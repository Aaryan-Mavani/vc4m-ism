import requests
import base64
import json

# URL of the Flask endpoint
url = "http://10.1.23.188:5000/process_audio"

# Path to the audio file
audio_file_path = "/media/chs.hdsi/DATA/whisper/ism.mp3"

# Read the audio file as binary data
with open(audio_file_path, "rb") as file:
    audio_content = file.read()


response = requests.post(url,files={'audio':audio_content} )

# Print the response from the server
print(json.loads(response.content.decode('utf-8'))['answer'])

def transcribe(audio):
    text = pipe(audio)["text"]
    return text


iface = gr.Interface(
    fn=transcribe,
    inputs=gr.Audio(source="microphone", type="filepath"),
    outputs="text",
    title="Whisper Small Hindi",
    description="Realtime demo for Hindi speech recognition using a fine-tuned Whisper small model.",
)

iface.launch()