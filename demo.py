import whisper

options = dict(beam_size=5, best_of=5)
translate_options = dict(task="transcribe",language="Hindi", **options)

model = whisper.load_model("small")
result = model.transcribe("ism.mp3", **translate_options)
print(result)