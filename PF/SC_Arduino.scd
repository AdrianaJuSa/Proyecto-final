/*
Adriana Juárez Santos
Conexión Arduino Super collider
Proyecto final
*/

SerialPort.devices;
~port = SerialPort.new (9600);

(
~charArray = [ ];_::
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a,{
			~val = ~charArray.collect (_.digit).convertDigits;
			~charArray = [ ];
			});
}.loop;
}).play;
)
//Presionar primero estas lineas
(
SynthDef.new(\saw, {
	arg cutoff=1000;
	var sig;
	sig = Saw.ar([50,51]);
	sig =RLPF.ar(sig, cutoff.lag(0.02),0.25,0.2);
	Out.ar(0, sig);
}).add;
)

//Presionar esta linea
//Se pueden modificar los valores
~synth = Synth(\saw, [\cutoff, 200]);

//Presionar esta linea
//Se pueden modificar los valores
~synth.set(\cutoff, 3000);
~synth.free;

~synth = Synth(\saw, [\cutoff, ~val.linexp(0, 1023, 80, 4000)]);
(
~control = Routine.new({
	{
		~synth.set(\cutoff, ~val.linexp(0, 1023, 80, 4000));
		0.02.wait;
	}.loop;
}).play;
)
~control.stop;
~synth.free;