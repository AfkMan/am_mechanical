use <reductor.scad>;

motor_axel_height=7.5;

translate([-2.5, 8.5, motor_axel_height])
tangent_reductor_worm();

translate([-23, 14.5, 0])
import("130_Micro_DC_Motor_3V-6V_8000RPM.stl");
