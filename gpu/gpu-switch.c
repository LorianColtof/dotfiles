#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdbool.h>

typedef enum {
    ACTION_ON,
    ACTION_OFF,
    ACTION_TOGGLE,
    ACTION_ERROR
} ActionType;

int main(int argc, char* argv[]) {
    FILE *f = fopen("/proc/acpi/bbswitch", "rw+");
    if (f == NULL) {
        perror("fopen");
        return 1;
    }

    ActionType action = ACTION_ERROR;
    if (argc == 2) {
        char* arg = argv[1];

        if (strcmp(arg, "on") == 0) {
            action = ACTION_ON;
        } else if (strcmp(arg, "off") == 0) {
            action = ACTION_OFF;
        } else if (strcmp(arg, "toggle") == 0) {
            action = ACTION_TOGGLE;
        }
    }

    if (action == ACTION_ERROR) {
        printf("Usage: %s [on|off|toggle]\n", argv[0]);
        return 1;
    }

    char *line = NULL;
    size_t len = 0;
    if (getline(&line, &len, f) != -1) {
        len = strlen(line);
        int gpu_on = 0;
        if (line[len - 3] == 'O' && line[len - 2] == 'N')
            gpu_on = 1;

        char *new_status;

        switch (action) {
            case ACTION_ON:
                new_status = "ON";
                break;
            case ACTION_OFF:
                new_status = "OFF";
                break;
            case ACTION_TOGGLE:
                new_status = gpu_on ? "OFF" : "ON";
                break;
            default:
                break;
        }
        fseek(f, 0, SEEK_SET);
        fprintf(f, new_status);

        if (errno != 0) {
            perror("write failed");
            return 1;
        }
    }
    fclose(f);
    return 0;
}
