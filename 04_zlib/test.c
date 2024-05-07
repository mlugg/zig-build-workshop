#include <stdio.h>
#include <stddef.h>
#include <zlib.h>

#define CHUNK 65536

static int decompress(FILE *source, FILE *dest) {
	int err;

	z_stream stream = {
		.zalloc = Z_NULL,
		.zfree = Z_NULL,
		.opaque = Z_NULL,
		.avail_in = 0,
		.next_in = Z_NULL,
	};

	err = inflateInit(&stream);
	if (err != Z_OK) return err;

	unsigned char in_buf[CHUNK];
	unsigned char out_buf[CHUNK];

	do {
		stream.avail_in = fread(in_buf, 1, CHUNK, source);
		stream.next_in = in_buf;
		if (ferror(source)) {
			(void)inflateEnd(&stream);
			return Z_ERRNO;
		}
		if (stream.avail_in == 0) break;
		do {
			stream.avail_out = CHUNK;
			stream.next_out = out_buf;
			err = inflate(&stream, Z_NO_FLUSH);
			switch (err) {
			case Z_NEED_DICT:
				err = Z_DATA_ERROR; // fallthrough
			case Z_DATA_ERROR:
			case Z_MEM_ERROR:
				(void)inflateEnd(&stream);
				return err;
			default:
			}
			size_t have_bytes = CHUNK - stream.avail_out;
			if (fwrite(out_buf, 1, have_bytes, dest) != have_bytes || ferror(dest)) {
				(void)inflateEnd(&stream);
				return Z_ERRNO;
			}
		} while (stream.avail_out == 0);
	} while (err != Z_STREAM_END);

	(void)inflateEnd(&stream);
	return err == Z_STREAM_END ? Z_OK : Z_DATA_ERROR;
}

int main(void) {
	FILE *in = fopen("test.z", "rb");
	if (!in) return 1;
	FILE *out = fopen("test", "wb");
	if (!out) {
		fclose(in);
		return 2;
	}
	int err = decompress(in, out);
	return err == Z_OK ? 0 : 3;
}
