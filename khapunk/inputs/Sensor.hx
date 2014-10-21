package khapunk.inputs;
import kha.input.SensorType;

/**
 * ...
 * @author Sidar Talei
 */
class Sensor
{

	public static var accX(default, null):Float = 0;
	public static var accY(default, null):Float = 0;
	public static var accZ(default, null):Float = 0;
	
	public static var gyroX(default, null):Float;
	public static var gyroY(default, null):Float;
	public static var gyroZ(default, null):Float;
	
	public static var accelerometerSupported(default, null):Bool = false;
	public static var gyroscopeSupported(default, null):Bool = false;
	
	@:allow(khapunk.inputs.Input)
	private static function init():Void{
		
		if (kha.input.Sensor.get(SensorType.Accelerometer) != null)
		{
			kha.input.Sensor.get(SensorType.Accelerometer).notify(onAccel);
			accelerometerSupported = true;
		}
		
		if (kha.input.Sensor.get(SensorType.Gyroscope) != null)
		{
			kha.input.Sensor.get(SensorType.Gyroscope).notify(onGyro);
			gyroscopeSupported = true;
		}
		
	}
		
	static private function onGyro(x: Float, y: Float, z: Float) : Void 
	{
		
		gyroX = x;
		gyroY = y;
		gyroZ = z;
	}
	
	static private function onAccel(x: Float, y: Float, z: Float) : Void 
	{
		accX = x;
		accY = y;
		accZ = z;
	}
}