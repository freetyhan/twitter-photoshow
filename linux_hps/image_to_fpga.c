#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include "address.h"

int open_physical (int);
void * map_physical (int, unsigned int, unsigned int);
void set_effect(uint8_t *effect_ptr, uint8_t effect);
void write_buffer(uint16_t * buf_ptr, uint16_t * data, int buffer);
int read_img(char * filename, uint16_t * output);

int main(void){
	uint16_t img_arr[480000];
	uint16_t *buf_ptr;
	uint16_t *bk_clr_ptr;
	uint8_t *effect_ptr;
	int fd = -1;
	fd = open_physical(fd);
	buf_ptr = (uint16_t *)map_physical(fd, BRIDGE, SDRAM_SPAN);
	bk_clr_ptr = (uint16_t *) map_physical(fd, BRIDGE | BG_CLR, BG_CLR_SPAN);

	//open config file
	FILE * fd_c = fopen("/home/root/Documents/updated_img/config.txt","r");
	if(fd_c == NULL){
		printf("Unable to read from config file\n");
		return;
	}

	int bk888 = 0;
	uint8_t effect = 0;
	int num_imgs = 0;

	fscanf(fd_c, "#%x",&bk888);
	fscanf(fd_c, "%d",&effect);
	fscanf(fd_c, "%d", &num_imgs);
	char files[num_imgs][60];	
	int i = 0;
	while(fscanf(fd_c, "%s", files[i]) == 1){
		i++;
	}
	fclose(fd_c);
	int tpi = 15;
	uint16_t bk565 = ((bk888 >> 19) << 11) | (((bk888 & 0xFF00 ) >> 10 ) << 5)| ((bk888 & 0xFF) >> 3);
	effect_ptr = (uint8_t *)bk_clr_ptr + 0x10;
	*(bk_clr_ptr) = bk565;

	char *loc = "/home/root/Documents/updated_img/";
	char file[100];
	int counter = 0;
	int err = 0;

	for(i = 0; i < num_imgs; i++){
		strcpy(file, loc);
		strcat(file, files[i]);
		printf("%s\n", file);
		err = read_img(file, img_arr);
		if(err == -1){
			printf("Unable to read image file");
			break;
		}
		write_buffer(buf_ptr, img_arr, i%2);
		sleep(tpi);
		if(effect == 0){
			set_effect(effect_ptr, counter%4+1);
			counter++;
		}else{
			set_effect(effect_ptr, effect);
		}
		/*strcpy(file, loc);
		strcat(file, files[i+1]);
		printf("%s\n", file);
		err = read_img(file, img_arr);
		if(err == -1)
			break;
		write_buffer(buf_ptr, img_arr, 1);
		sleep(tpi);
		if(effect == 0){
			set_effect(effect_ptr, counter%2+1);
			counter++;
		}else{
			set_effect(effect_ptr, effect);
		}*/
	}	
	if(num_imgs %2 == 1){
		sleep(tpi);
		if(effect ==0)
			set_effect(effect_ptr, counter%4+1);
		else
			set_effect(effect_ptr, effect);
	}
	return 0;
}

//sets desired effect and switches buffers
void set_effect(uint8_t *effect_ptr, uint8_t effect) {
	*(effect_ptr) = effect << 1;
	*(effect_ptr) += 1;
	if(effect == 1){
		sleep(1.52);
	}else{
		sleep(3.57);
	}
	*(effect_ptr) -= 1;
	return;
}
//writes given data to desired buffer in SDRAM
void write_buffer(uint16_t * buf_ptr, uint16_t * data, int buffer){
	int i,j;
	for(i = 599; i >= 0; i--){
		for(j = 0; j < 800; j++){
			*(buf_ptr + buffer*480000 + (599-i)*800 + j) = data[i*800 + j];
		}
	}
}

//reads image from file to output array
int read_img(char * filename, uint16_t * output){
	FILE * fd = fopen(filename, "r");
	if(fd == NULL){
		return -1;
	}
	int i;
	uint16_t pixel;
	for(i = 0; i < 480000; i++){
		fscanf(fd, "%hx,", &pixel);
		output[i] = pixel;					
	}
	fclose(fd);
	return 0;
}


/* Open /dev/mem to give access to physical addresses */
int open_physical (int fd){
    if (fd == -1) // check if already open
        if ((fd = open( "/dev/mem", (O_RDWR | O_SYNC))) == -1){
            printf ("ERROR: could not open \"/dev/mem\"...\n");
            return (-1);
        }
    return fd;
}

/* Establish a virtual address mapping for the physical addresses starting
* at base and extending by span bytes */
void* map_physical(int fd, unsigned int base, unsigned int span){
    void *virtual_base;
    // Get a mapping from physical addresses to virtual addresses
    virtual_base = mmap (NULL, span, (PROT_READ | PROT_WRITE), MAP_SHARED,
                        fd, base);
    if (virtual_base == MAP_FAILED){
        printf ("ERROR: mmap() failed...\n");
        close (fd);
        return (NULL);
    }
    return virtual_base;
}
