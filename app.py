from flask import Flask, render_template, request, jsonify, send_file
import pyaudio
import wave
import os
import requests
import json
from gtts import gTTS

app = Flask(__name__)

# URL of the Flask endpoint
API_URL = "http://10.1.23.188:5010/process_audio"

# Function to record audio from the microphone
def record_audio(filename, duration=10):
    CHUNK = 1024
    FORMAT = pyaudio.paInt16
    CHANNELS = 1
    RATE = 44100
    RECORD_SECONDS = duration
    
    p = pyaudio.PyAudio()
    
    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    frames_per_buffer=CHUNK)
    
    print("* Recording audio...")
    frames = []
    
    for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
        data = stream.read(CHUNK)
        frames.append(data)
    
    print("* Finished recording.")
    
    stream.stop_stream()
    stream.close()
    p.terminate()
    
    wf = wave.open(filename, 'wb')
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(p.get_sample_size(FORMAT))
    wf.setframerate(RATE)
    wf.writeframes(b''.join(frames))
    wf.close()

# Function to convert text to speech with longer text support
def text_to_speech(text, filename):
    # Split text into smaller chunks for better processing
    max_chars_per_chunk = 300
    chunks = [text[i:i + max_chars_per_chunk] for i in range(0, len(text), max_chars_per_chunk)]

    with open(filename, 'wb') as f:
        for i, chunk in enumerate(chunks):
            # Remove any non-ASCII characters and punctuation
            clean_chunk = ''.join(char for char in chunk if char.isalnum() or char.isspace())
            
            # Skip empty chunks
            if not clean_chunk.strip():
                continue
            
            tts = gTTS(text=clean_chunk, lang='hi', slow=False)
            tts.write_to_fp(f)
            
            # Insert a small pause between chunks to prevent clipping
            if i != len(chunks) - 1:
                f.write(b'\n\n')

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/record/start', methods=['POST'])
def start_record():
    try:
        record_audio("temp_audio.wav")  # Overwrite the existing file
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/record/stop', methods=['POST'])
def stop_record():
    try:
        # Stop recording logic, if any
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/record/response')
def get_response():
    try:
        response = requests.post(API_URL, files={'audio': open("temp_audio.wav", "rb")})
        api_response = json.loads(response.content.decode('utf-8'))['answer']

        # Convert API response text to speech
        text_to_speech(api_response, "response_audio.mp3")

        return jsonify({'answer': api_response})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/play')
def play_audio():
    return send_file("response_audio.mp3", mimetype="audio/mp3", as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True, port=5006)
