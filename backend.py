import torch
import accelerate
from flask import Flask, jsonify, request
from flask_cors import CORS
import whisper
import numpy as np
import base64
import struct

# Initialize Flask app
app = Flask(__name__)

# Enable Cross-Origin Resource Sharing (CORS)
CORS(app)

# Load the model
model = whisper.load_model("large")
options = dict(beam_size=5, best_of=5)
translate_options = dict(task="transcribe", language="Hindi", **options)

# Define endpoint for processing audio
@app.route('/process_audio', methods=['POST'])
def process_audio():
    if request.method == 'POST':
        # Get the Base64-encoded audio data
        audio_content = request.files['audio']#.json.get('audio_base64')
        # audio_content=struct.unpack(audio_base64)
        audio_content.save('temp.mp3')
        # with open('temp.mp3','wb') as f:
        #     f.write(audio_content)
        # audio_base64=pickle.loads(audio_base64)
        # try:
        # Decode Base64 and convert to raw audio data
        # audio_data = base64.b64decode(audio_base64).decode('unicode-escape').encode('ISO-8859-1')[2:-1]
        
        # Convert raw audio data to numpy array of 16-bit integers
        # audio_np = np.frombuffer(audio_base64.encode(), dtype=np.int16).astype(np.double)
        # print(audio_np)
        # Process audio and generate answer
        result = model.transcribe('temp.mp3', **translate_options)
        print(result)
        return jsonify({"answer": result['text']})
        # except Exception as e:
        #      return jsonify({"error": str(e)})

if __name__ == '__main__':
    # Run the app on all network interfaces on port 5000
    app.run(debug=False, host='0.0.0.0', port=8080)