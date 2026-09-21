"""独立教学 u4 容器；不是 AIMET 导出格式或 GPU kernel。"""
import struct


def pack_u4(values):
    codes = list(values)
    if any(type(q) is not int or not 0 <= q <= 15 for q in codes):
        raise ValueError('u4 code must be an integer in [0, 15]')
    out = bytearray((len(codes) + 1) // 2)
    for i, q in enumerate(codes):
        out[i // 2] |= q << (4 * (i % 2))
    return bytes(out)


def unpack_u4(payload, count):
    if count < 0 or len(payload) != (count + 1) // 2:
        raise ValueError('payload size mismatch')
    if count % 2 and payload[-1] >> 4:
        raise ValueError('nonzero tail nibble')
    return [(payload[i // 2] >> (4 * (i % 2))) & 15 for i in range(count)]


def self_check():
    cases = [[], [0], [15], list(range(16)), list(range(16)) + [7]]
    for codes in cases:
        assert unpack_u4(pack_u4(codes), len(codes)) == codes
    for bad in ([-1], [16], [1.5]):
        try:
            pack_u4(bad)
        except ValueError:
            pass
        else:
            raise AssertionError('bad code accepted')
    for payload, count in ((b'\xf1', 1), (b'', 1), (b'', -1)):
        try:
            unpack_u4(payload, count)
        except ValueError:
            pass
        else:
            raise AssertionError('bad payload accepted')
    # affine metadata 的二进制存储契约为每通道 float32 scale + int32 offset。
    assert struct.calcsize('<fi') == 8
    print('PASS independent u4 packing: 5 roundtrips, 6 invalid inputs, 8-byte scale/offset record')


if __name__ == '__main__':
    self_check()
