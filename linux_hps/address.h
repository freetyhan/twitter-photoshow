#define BRIDGE 0xC0000000
#define BG_CLR 0x4000000
#define EFFECT 0x4000010
#define BG_CLR_SPAN 0x1F
#define BRIDGE_SPAN 0x400001F
#define SDRAM 0x0
#define SDRAM_SPAN 0x3FFFFFF

int open_physical (int);
void * map_physical (int, unsigned int, unsigned int);
void set_effect(uint8_t *effect_ptr, uint8_t effect);
void write_buffer(uint16_t * buf_ptr, uint16_t * data, int buffer);
int read_img(char * filename, uint16_t * output);