string beat_files[6];

"beats/otf_01" => beat_files[0];
"beats/otf_02" => beat_files[1];
"beats/otf_03" => beat_files[2];
"beats/otf_04" => beat_files[3];
"beats/otf_05" => beat_files[4];
"beats/otf_06" => beat_files[5];

// default file
"data_test.txt" => string filename;

// look at command line
if( me.args() > 0 ) me.arg(0) => filename;

// open a file
FileIO fio;
fio.open( filename, FileIO.READ );

fun void fives()
{
  5000::ms => now;
}

fun void random_funk()
{
  Std.rand2(1,20) => int random;
  if (random > 19)
  {
    Machine.add(beat_files[5]) => int special_beat;
    fives();
    Machine.replace(special_beat, beat_files[4]);
    fives();
    Machine.remove(special_beat);
  }
  if (random > 18 && random <= 19)
  {
    Machine.add(beat_files[4]) => int special_beat;
    fives();
    Machine.replace(special_beat, beat_files[3]);
    fives();
    Machine.remove(special_beat);
  }
}

fun void beatify( int value )
{
  if ( value <= 10 )
  {
    Machine.add(beat_files[value/2]) => int something_useful;

    if (value == 0)
    {
      random_funk();
      1000::ms => now;
    }
    if (value == 2)
    {
      random_funk();
      2000::ms => now;
    }
    else
      (value*2000)::ms => now;

    Machine.remove( something_useful );
  }
  else
  {
    Machine.add(beat_files[(value%10)/2]) => int other_something_useful;
    (value*1000)::ms => now;

    Machine.remove( other_something_useful );
  }
}

// ensure file is ok
if( !fio.good() )
{
  cherr <= "can't open file: " <= filename <= " for reading..."
        <= IO.newline();
  me.exit();
}

// variable to read into
int val;

// loop until end <-- except it doesn't seem to ever die...
while( fio => val )
{
  cherr <= val <= IO.newline();

  // sporkage!!
  spork ~ beatify( val );
  500::ms => now;
}
