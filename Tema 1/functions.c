#include "functions.h"
#include "structs.h"
#include "operations.h"
#include <stdio.h>
#include <stdlib.h>

/*
This function allocates the array of sensors given the number of them.
*/
sensor *alloc_array(int nr_sens)
{
	sensor *sensor_array = malloc(nr_sens * sizeof(sensor));
	return sensor_array;
}

/*
This function reads the data for a tire sensor.
*/
void *read_tire(sensor *sensor_array, FILE *file)
{
	tire_sensor *tire = malloc(sizeof(tire_sensor));
	fread(tire, sizeof(tire_sensor), 1, file);
	return tire;
}

/*
This function reads the data for a PMU sensor.
*/
void *read_PMU(sensor *sensor_array, FILE *file)
{
	power_management_unit *pmu = malloc(sizeof(power_management_unit));
	fread(pmu, sizeof(power_management_unit), 1, file);
	return pmu;
}

/*
This function reads the number of instructions and the instructions themselves.
*/
void read_operations(sensor *sensor_array, int index, FILE *file)
{
	fread(&sensor_array[index].nr_operations, sizeof(int), 1, file);

	int nr_op = sensor_array[index].nr_operations;
	sensor_array[index].operations_idxs = malloc(nr_op * sizeof(int));
	fread(sensor_array[index].operations_idxs, sizeof(int), nr_op, file);
}

/*
This function reads the data for the array of sensors and at the end sorts them.
*/
void read_data(sensor **sensor_array, int nr_sens, FILE *file)
{
	sensor *arr = (*sensor_array);
	for (int i = 0 ; i < nr_sens ; ++i) {
		fread(&arr[i].sensor_type, sizeof(enum sensor_type), 1, file);

		if (!arr[i].sensor_type)
			arr[i].sensor_data = read_tire(arr, file);
		else
			arr[i].sensor_data = read_PMU(arr, file);

		read_operations(arr, i, file);
	}
	sort_sensors(sensor_array, nr_sens);
}

/*
This function sorts the array by first putting the PMU sensors and after that
the tire sensors. This allows the analyze and the print functions to work
properly.
*/
void sort_sensors(sensor **sensor_array, int nr_sens)
{
	int *new_order = malloc(nr_sens * sizeof(int)), i = 0;
	sensor *aux_arr = malloc(nr_sens * sizeof(sensor));

	for (int k = 0 ; k < nr_sens ; ++k)
		if ((*sensor_array)[k].sensor_type)
			new_order[i++] = k;

	for (int k = 0 ; k < nr_sens ; ++k)
		if (!(*sensor_array)[k].sensor_type)
			new_order[i++] = k;

	for (int i = 0 ; i < nr_sens ; ++i) {
		aux_arr[i] = (*sensor_array)[new_order[i]];
	}

	free((*sensor_array));
	(*sensor_array) = aux_arr;
	free(new_order);
}

/*
This function is called after the data was read and it keeps reading
instructions until the command exit is requested. Each command is responsable
for calling a function.
*/
void process_instructions(sensor *sensor_array, int nr_sens)
{
	char command[NMAX];
	int sensor_idx;

	do {
		scanf("%s", command);
		if (!strcmp(command, "print")) {
			scanf("%d", &sensor_idx);
			print_sensors(sensor_array, nr_sens, sensor_idx);
		} else if (!strcmp(command, "analyze")) {
			scanf("%d", &sensor_idx);
			analyze_sensors(sensor_array, nr_sens, sensor_idx);
		} else if (!strcmp(command, "clear")) {
			clear_sensors(&sensor_array, &nr_sens);
		}
	} while (strcmp(command, "exit"));

	exit_sensors(sensor_array, nr_sens);
}

/*
This functions prints the array of sensors.
*/
void print_sensors(sensor *sensor_array, int nr_sens, int index)
{
	if (index < 0 || index >= nr_sens) {
		printf("Index not in range!\n");
		return;
	}

	if (sensor_array[index].sensor_type == 0)
		print_tire(sensor_array, index);
	else
		print_PMU(sensor_array, index);
}

/*
This function is used for printing a single tire sensor.
*/
void print_tire(sensor *sensor_array, int index)
{
	tire_sensor *tire = sensor_array[index].sensor_data;

	printf("Tire Sensor\n");
	printf("Pressure: %.2f\n", tire->pressure);
	printf("Temperature: %.2f\n", tire->temperature);
	printf("Wear Level: %d%%\n", tire->wear_level);
	if (tire->performace_score)
		printf("Performance Score: %d\n", tire->performace_score);
	else
		printf("Performance Score: Not Calculated\n");
}

/*
This function is used for printing a single PMU sensor.
*/
void print_PMU(sensor *sensor_array, int index)
{
	power_management_unit *pmu = sensor_array[index].sensor_data;

	printf("Power Management Unit\n");
	printf("Voltage: %.2f\n", pmu->voltage);
	printf("Current: %.2f\n", pmu->current);
	printf("Power Consumption: %.2f\n", pmu->power_consumption);
	printf("Energy Regen: %d%%\n", pmu->energy_regen);
	printf("Energy Storage: %d%%\n", pmu->energy_storage);
}

/*
This function creates an array of type void * in order to call the functions by
their index number.
*/
void analyze_sensors(sensor *sensor_array, int nr_sens, int index)
{
	if (index < 0 || index >= nr_sens) {
		printf("Index not in range!\n");
		return;
	}

	void (*op[8]) (void *);
	void *oper[8];

	get_operations(oper);

	for (int i = 0; i < 8; i++) {
		op[i] = oper[i];
	}
	for (int i = 0 ; i < sensor_array[index].nr_operations ; ++i) {
		(op[sensor_array[index].operations_idxs[i]])
		(sensor_array[index].sensor_data);
	}
}

/*
This function checks if a sensor is maulfunctioning.
*/
int check_sensor(sensor sensor)
{
	if (sensor.sensor_type) {
		power_management_unit *pmu = sensor.sensor_data;
		if (pmu->voltage < 10 || pmu->voltage > 20)
			return 0;
		if (pmu->current < -100 || pmu->current > 100)
			return 0;
		if (pmu->power_consumption < 0 || pmu->power_consumption > 1000)
			return 0;
		if (pmu->energy_regen < 0 || pmu->energy_regen > 100)
			return 0;
		if (pmu->energy_storage < 0 || pmu->energy_storage > 100)
			return 0;
	} else {
		tire_sensor *tire = sensor.sensor_data;
		if (tire->pressure < 19 || tire->pressure > 28)
			return 0;
		if (tire->temperature < 0 || tire->temperature > 120)
			return 0;
		if (tire->wear_level < 0 || tire->wear_level > 100)
			return 0;
	}
	return 1;
}

/*
This function removes the sensors that are malfunctioning and resizes the array
to the new size.
*/
void clear_sensors(sensor **sensor_array, int *nr_sens)
{
	sensor *arr = (*sensor_array);
	int sens_size = sizeof(sensor);
	for (int i = 0 ; i < *nr_sens ; ++i) {
		if (!check_sensor(arr[i])) {
			free(arr[i].operations_idxs);

			if (arr[i].sensor_type)
				free(arr[i].sensor_data);
			else
				free(arr[i].sensor_data);

			memmove(&arr[i], &arr[i + 1], ((*nr_sens) - i - 1) * sens_size);

			(*nr_sens)--;
			i--;
		}
	}
	(*sensor_array) = realloc((*sensor_array), (*nr_sens) * sens_size);
}

/*
This function frees the data from each sensor and frees the array.
*/
void exit_sensors(sensor *sensor_array, int nr_sens)
{
	for (int i = 0 ; i < nr_sens ; ++i) {
		free(sensor_array[i].operations_idxs);
		if (sensor_array[i].sensor_type)
			free(sensor_array[i].sensor_data);
		else
			free(sensor_array[i].sensor_data);
	}
	free(sensor_array);
}
