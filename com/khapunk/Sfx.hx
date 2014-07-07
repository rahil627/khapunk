package com.khapunk;
import kha.Loader;
import kha.Sound;
import kha.SoundChannel;

/**
 * ...
 * @author Sidar Talei
 */
class Sfx
{
	var sound:Sound;
	var soundChannel:SoundChannel;
	public function new(sound:Dynamic) 
	{
		if (Std.is(sound, String))
		{
			this.sound = Loader.the.getSound(cast(sound,String));
		}
		else if (Std.is(sound, Sound))
		{
			this.sound = sound;
		}
	}
	
	public function play(volume: Float = 1) : Void
	{
		if ( soundChannel == null )
		{
			soundChannel = sound.play();
		}
		soundChannel.setVolume(volume);
	}
	
	public function stop() : Void
	{
		if (soundChannel != null)
		{
			soundChannel.stop();
		}
	}
}