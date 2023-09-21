#pragma once
#include "structs.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define NMAX 1000

sensor *alloc_array(int nr_sens);

void read_data(sensor **senor_array, int nr_sens, FILE *file);
void *read_tire(sensor *sensor_array, FILE *file);
void *read_PMU(sensor *sensor_array, FILE *file);
void read_operations(sensor *sensor_array, int index, FILE *file);

void print_sensors(sensor *sensor_array, int nr_sens, int index);
void print_tire(sensor *sensor_array, int index);
void print_PMU(sensor *sensor_array, int index);

void process_instructions(sensor *sensor_array, int nr_sens);
void sort_sensors(sensor **sensor_array, int nr_sens);
int check_sensor(sensor sensor_array);
void analyze_sensors(sensor *sensor_array, int nr_sens, int index);

void clear_sensors(sensor **sensor_array, int *nr_sens);
void exit_sensors(sensor *sensor_array, int nr_sens);
