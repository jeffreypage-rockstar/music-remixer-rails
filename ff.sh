# ffmpeg -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_1.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_2.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_3.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_4.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_5.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_6.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_7.wav' -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix_audio_part_8.wav' -filter_complex 'concat=n=8:v=0:a=1'  '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix-audio-b09cf7f480dadb5f7f54196d42aa2c4a.wav'

ffmpeg -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix-audio-b09cf7f480dadb5f7f54196d42aa2c4a.wav' -b:a 192k -af 'compand=attacks=0:points=-80/-80|-.3/-.3|20/-.3' -y foo.m4a

# ffmpeg -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix-audio-b09cf7f480dadb5f7f54196d42aa2c4a.wav' -b:a 192k foo.m4a



ffmpeg -i '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix-audio-fcad75bd7d18b397d5332b5213dc614a.wav' '-b:a 192k -af 'compand=attacks=0:points=-80/-80|-.3/-.3|20/-.3' -y '/Users/mpuckett/mix8/akashic-nga/master/public/uploads/tmp/1c0197b0b62fdf517d4c836d/mix-audio-fcad75bd7d18b397d5332b5213dc614a.m4a'