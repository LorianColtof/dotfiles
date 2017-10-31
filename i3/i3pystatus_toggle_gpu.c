#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int main() {
    FILE *f = fopen("/proc/acpi/bbswitch", "rw+");
    if (f == NULL) {
        perror("fopen");
        return 1;
    }

    char *line = NULL;
    size_t len = 0;
    if (getline(&line, &len, f) != -1) {
        len = strlen(line);
        int gpu_on = 0;
        if (line[len - 3] == 'O' && line[len - 2] == 'N')
            gpu_on = 1;

        char *new_status = gpu_on ? "OFF" : "ON";
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
