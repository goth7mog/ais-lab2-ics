PROGRAM SimpleProcess
  VAR
    Tank_Level   AT %IW0 : INT := 0;
    Pump_On      AT %QX0.0 : BOOL := FALSE;
    Valve_Open   AT %QX0.1 : BOOL := FALSE;
    Setpoint     : INT := 500;
    High_Alarm   : INT := 800;
    Low_Alarm    : INT := 200;
  END_VAR

  IF Tank_Level < Setpoint THEN
    Pump_On := TRUE;
    Valve_Open := FALSE;

  ELSIF Tank_Level > High_Alarm THEN
    Pump_On := FALSE;
    Valve_Open := TRUE;

  ELSE
    Pump_On := FALSE;
    Valve_Open := FALSE;

  END_IF;
END_PROGRAM
