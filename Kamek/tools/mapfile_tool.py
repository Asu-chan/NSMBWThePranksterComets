# half assed

# d_profile: same place
# d_bases: same place
# d_enemies and part of d_bases: offset by 0x20
# d_en_boss: offset by 0x20

def read_num(idx, s):
	num = 0

	while True:
		num = (num * 10) + int(s[idx])
		idx += 1
		if not s[idx].isdigit():
			return idx,num

def read_vl_string(idx, name):
	idx, slen = read_num(idx, name)
	s = name[idx:idx+slen]
	idx += slen
	return idx, s

def read_class_name(idx, name):
	if name[idx] == 'Q':
		ns_elem_ct = int(name[idx + 1])
		ns_elems = []
		idx += 2
		for i in xrange(ns_elem_ct):
			idx, n = read_vl_string(idx, name)
			ns_elems.append(n)
		return idx, ns_elems
	else:
		idx, n = read_vl_string(idx, name)
		return idx, [n]

class BuiltInType(object):
	no_compress = True
	def __init__(self, char, name):
		self.char = char
		self.name = name
	def output(self):
		output.append(self.char)
	def __str__(self):
		return self.name

def Char(): return BuiltInType('c', 'char')
def UChar(): return BuiltInType('h', 'unsigned char')
def Short(): return BuiltInType('s', 'short')
def UShort(): return BuiltInType('t', 'unsigned short')
def Int(): return BuiltInType('i', 'int')
def UInt(): return BuiltInType('j', 'unsigned int')
def Long(): return BuiltInType('l', 'long')
def ULong(): return BuiltInType('m', 'unsigned long')
def Float(): return BuiltInType('f', 'float')
def Double(): return BuiltInType('d', 'double')
def WChar(): return BuiltInType('w', 'wchar_t')
def Void(): return BuiltInType('v', 'void')
def Bool(): return BuiltInType('b', 'bool')
def Ellipsis(): return BuiltInType('z', '...')

class Reference(object):
	def __init__(self, thing):
		self.thing = thing
	def output(self):
		if compress(self): return
		output.append('R')
		self.thing.output()
		add_compress(self.thing)
	def __str__(self):
		return '%s&' % self.thing

class Pointer(object):
	def __init__(self, thing):
		self.thing = thing
	def output(self):
		if compress(self): return
		output.append('P')
		self.thing.output()
		add_compress(self.thing)
	def __str__(self):
		return '%s*' % self.thing

SIMPLE_NAMES = {
	'__ct': 'C1',
	'__dt': 'D1',
	'__nw': 'nw',
	'__dl': 'dl',
	'__nwa': 'na',
	'__dla': 'da',
}

class Name(object):
	def __init__(self, name):
		self.name = name
	def output(self, trash_me=False, include_const=False):
		if include_const: raise 'OH NO'
		if compress(self): return

		try:
			output.append(SIMPLE_NAMES[self.name])
		except KeyError:
			output.append(str(len(self.name)) + self.name)

	def __str__(self):
		return self.name

class NestedName(object):
	def __init__(self, *bits):
		if len(bits) > 2:
			self.parent = NestedName(*bits[:-1])
		else:
			self.parent = bits[0]
		self.name = bits[-1]
	def output(self, nested=False, include_const=False):
		if isinstance(self.name, Name) and self.name.name == '__vt':
			# a hack.
			output.append('TV')
			self.parent.output()
			return

		if compress(self): return

		if not nested:
			output.append('N')
			if include_const:
				output.append('K')

		self.parent.output(True)
		self.name.output()

		if not nested:
			output.append('E')
		add_compress(self.parent)

	def __str__(self):
		return str(self.parent) + '::' + str(self.name)

class Function(object):
	def __init__(self, name, params, is_const=False):
		self.name = name
		self.params = params
		self.is_const = is_const
	def output(self):
		self.name.output(include_const=self.is_const)
		for param in self.params:
			param.output()
			add_compress(param)
	def __str__(self):
		param_str = ', '.join(map(str, self.params))
		const_str = ' const' if self.is_const else ''
		return '%s(%s)%s' % (self.name, param_str, const_str)

class GenericFunction(object):
	def __init__(self, ret_type, params):
		self.ret_type = ret_type
		self.params = params
	def output(self):
		if compress(self): return
		output.append('F')

		self.ret_type.output()
		add_compress(self.ret_type)

		for param in self.params:
			param.output()
			add_compress(param)

		output.append('E')
	def __str__(self):
		param_str = ', '.join(map(str, self.params))
		return '%s ()(%s)' % (self.ret_type, param_str)

class Array(object):
	def __init__(self, elem_type, size):
		self.elem_type = elem_type
		self.size = size
	def output(self):
		if compress(self): return
		output.append('A')
		output.append(str(self.size))
		output.append('_')
		self.elem_type.output()
		add_compress(self.elem_type)
	def __str__(self):
		return '%s[%d]' % (self.elem_type, self.size)

class Const(object):
	def __init__(self, thing):
		self.thing = thing
	def output(self):
		if compress(self): return
		output.append('K')
		self.thing.output()
		add_compress(self.thing)
	def __str__(self):
		return '%s const' % self.thing

def canonicalise_compress(obj):
	if isinstance(obj, str):
		return obj
	else:
		return str(obj)
def add_compress(piece):
	if hasattr(piece, 'no_compress'):
		return
	piece = canonicalise_compress(piece)
	if piece not in comp_bits:
		comp_bits.append(piece)

compress_ids = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
def pack_compress_idx(idx):
	if idx == 0:
		return 'S_'
	else:
		return 'S%s_' % compress_ids[idx - 1]

def compress(piece):
	piece = canonicalise_compress(piece)
	try:
		idx = comp_bits.index(piece)
		output.append(pack_compress_idx(idx))
		return True
	except ValueError:
		# not found
		return False

def mangle(thing):
	global comp_bits, output
	comp_bits = []
	output = []
	thing.output()
	return '_Z' + ''.join(output)

# fname = NestedName(Name('ActivePhysics'), Name('InitWithStruct'))
# info = NestedName(Name('ActivePhysics'), Name('Info'))
# actor = Name('dActor_c')
# params = [Pointer(Const(info)), Pointer(actor)]
# func = Function(fname, params)
# print mangle(func)

# fname = NestedName(Name('mMtx'), Name('applyRotationYXZ'))
# ps = Pointer(Short())
# func = Function(fname, [ps,ps,ps])
# print mangle(func)

# fname = NestedName(Name('a'), Name('b'), Name('c'))
# print mangle(fname)

# import sys
# sys.exit()


def read_type(idx, name, unsigned=False):
	char = name[idx]
	idx += 1

	if char == 'U':
		return read_type(idx, name, True)
	elif char.isdigit() or char == 'Q':
		idx -= 1
		idx, t = read_class_name(idx, name)
		if len(t) == 1:
			return idx, Name(t[0])
		else:
			return idx, NestedName(*map(Name, t))
	elif char == 'P':
		idx, t = read_type(idx, name)
		return idx, Pointer(t)
	elif char == 'R':
		idx, t = read_type(idx, name)
		return idx, Reference(t)
	elif char == 'C' or char == 'K':
		idx, t = read_type(idx, name)
		return idx, Const(t)
	elif char == 'v':
		return idx, Void()
	elif char == 'b':
		return idx, Bool()
	elif char == 'f':
		return idx, Float()
	elif char == 'd':
		return idx, Double()
	elif char == 'w':
		return idx, WChar()
	elif char == 'c':
		return idx, (UChar if unsigned else Char)()
	elif char == 's':
		return idx, (UShort if unsigned else Short)()
	elif char == 'i':
		return idx, (UInt if unsigned else Int)()
	elif char == 'l':
		return idx, (ULong if unsigned else Long)()
	elif char == 'e':
		return idx, Ellipsis()
	elif char == 'F':
		idx -= 1
		idx, params = read_func_params(idx, name)
		idx, ret_type = read_type(idx, name)
		return idx, GenericFunction(ret_type, params)
	elif char == 'A':
		idx, size = read_num(idx, name)
		assert name[idx] == '_'
		idx += 1
		idx, atype = read_type(idx, name)
		return idx, Array(atype, size)
	else:
		print 'Unknown: ' + char + ' @ ' + name
		return idx, None

def read_func_params(idx, name):
	assert name[idx] == 'F'
	idx += 1
	params = []

	while idx < len(name):
		if name[idx] == '_':
			idx += 1
			break
		idx, t = read_type(idx, name)
		params.append(t)

	return idx, params

def from_cw(name):
	split_offs = name.rfind('__')
	if split_offs > 0:
		global comp_bits
		comp_bits = []

		is_const = False

		# print 'IN:  ' + name
		base_name = name[:split_offs]
		idx = split_offs + 2
		if name[idx] == 'F':
			# No class, just a function
			ptype = []
		else:
			# Got class
			idx, ptype = read_class_name(idx, name)

		if not ptype:
			f_name = Name(base_name)
		else:
			f_name = NestedName(*map(Name, ptype + [base_name]))

		if idx == len(name):
			# This must be a var
			return f_name

		if name[idx] == 'C':
			idx += 1
			is_const = True

		f_params = []

		idx, f_params = read_func_params(idx, name)
		return Function(f_name, f_params, is_const)
	return None


def make_hex_offset(offs):
	return '0x%08X' % offs

def fix_offs_pal_v1(offs):
	return offs

def fix_offs_pal_v2(offs):
	if offs >= 0x80000000 and offs <= 0x800cf29f:
		return offs+ 0x0

	if offs >= 0x800cf2a0 and offs <= 0x800cf2a3:
		return offs+ 0x4

	if offs >= 0x800cf2a4 and offs <= 0x800cf303:
		return offs+ 0x8

	if offs >= 0x800cf304 and offs <= 0x800cf307:
		return offs+ 0xc

	if offs >= 0x800cf308 and offs <= 0x800cf30f:
		return offs+ 0x18

	if offs >= 0x800cf320 and offs <= 0x800cf327:
		return offs- 0x8

	if offs >= 0x800cf328 and offs <= 0x800cf6e7:
		return offs+ 0x0

	if offs >= 0x800cf6e8 and offs <= 0x800cf6eb:
		return offs+ 0x4

	if offs >= 0x800cf6ec and offs <= 0x800cf73b:
		return offs+ 0x8

	if offs >= 0x800cf73c and offs <= 0x800cf73f:
		return offs+ 0xc

	if offs >= 0x800cf740 and offs <= 0x800cf7e7:
		return offs+ 0x10

	if offs >= 0x800cf7e8 and offs <= 0x800cf7eb:
		return offs+ 0x14

	if offs >= 0x800cf7ec and offs <= 0x800cf7f3:
		return offs+ 0x20

	if offs >= 0x800cf804 and offs <= 0x800cf80b:
		return offs+ 0x0

	if offs >= 0x800cf80c and offs <= 0x800cf907:
		return offs+ 0x8

	if offs >= 0x800cf910 and offs <= 0x800e0d2b:
		return offs+ 0x0

	if offs >= 0x800e0d30 and offs <= 0x800e0d3f:
		return offs- 0x4

	if offs >= 0x800e0d44 and offs <= 0x800e0d4b:
		return offs- 0x8

	if offs >= 0x800e0d4c and offs <= 0x800e0ddb:
		return offs+ 0x10

	if offs >= 0x800e0de4 and offs <= 0x800e0df7:
		return offs+ 0x8

	if offs >= 0x800e0dfc and offs <= 0x800e0e0b:
		return offs+ 0x4

	if offs >= 0x800e0e10 and offs <= 0x807683f6:
		return offs+ 0x0

	if offs >= 0x807683f7 and offs <= 0x8076842b:
		return offs+ 0xf

	if offs >= 0x8076842c and offs <= 0x80768462:
		return offs+ 0x1e

	if offs >= 0x80768463 and offs <= 0x8076849b:
		return offs+ 0x2d

	if offs >= 0x8076849c and offs <= 0x8076849f:
		return offs+ 0x3c

	if offs >= 0x807684a0 and offs <= 0x807aaa30:
		return offs+ 0x40

	if offs >= 0x807aaa6c and offs <= 0x809907ff:
		return offs+ 0x10

	if offs >= 0x80990800:
		return offs+ 0x20

	return offs

def fix_offs_ntsc_v1(offs):
	if offs >= 0x80000000 and offs <= 0x800b4600:
		return offs+ 0x0

	if offs >= 0x800b4630 and offs <= 0x800b463f:
		return offs- 0x20

	if offs >= 0x800b4650 and offs <= 0x800b466b:
		return offs- 0x1c

	if offs >= 0x800b4670 and offs <= 0x800b46bb:
		return offs- 0x20

	if offs >= 0x800b46cc and offs <= 0x800b46fb:
		return offs- 0x30

	if offs >= 0x800b4724 and offs <= 0x800b475f:
		return offs- 0x58

	if offs >= 0x800b4760 and offs <= 0x800c8daf:
		return offs- 0x50

	if offs >= 0x800c8e50 and offs <= 0x800e4c5f:
		return offs- 0xf0

	if offs >= 0x800e4c60 and offs <= 0x800e4c63:
		return offs- 0xe8

	if offs >= 0x800e4c64 and offs <= 0x800e4c6b:
		return offs- 0xf4

	if offs >= 0x800e4c6c and offs <= 0x800e4d6f:
		return offs- 0xf0

	if offs >= 0x800e4d94 and offs <= 0x800e4d9b:
		return offs- 0x114

	if offs >= 0x800e4da0 and offs <= 0x800e4ebf:
		return offs- 0x114

	if offs >= 0x800e4ec0 and offs <= 0x8010f203:
		return offs- 0x110

	if offs >= 0x8010f234 and offs <= 0x8010f237:
		return offs- 0x134

	if offs >= 0x8010f238 and offs <= 0x8010f243:
		return offs- 0x144

	if offs >= 0x8010f244 and offs <= 0x802bb6bf:
		return offs- 0x140

	if offs >= 0x802bb6d0 and offs <= 0x802bb74f:
		return offs- 0x150

	if offs >= 0x802bb860 and offs <= 0x802bbbff:
		return offs- 0x260

	if offs >= 0x802bbc90 and offs <= 0x802edccf:
		return offs- 0x2f0

	if offs >= 0x802edce0 and offs <= 0x80317737:
		return offs- 0x300

	if offs >= 0x80317750 and offs <= 0x80322ffb:
		return offs- 0x318

	if offs >= 0x80323000 and offs <= 0x8032301b:
		return offs- 0x31c

	if offs >= 0x80323020 and offs <= 0x8032307b:
		return offs- 0x320

	if offs >= 0x80323080 and offs <= 0x803230cf:
		return offs- 0x324

	if offs >= 0x803230e8 and offs <= 0x803230ff:
		return offs- 0x33c

	if offs >= 0x8032310c and offs <= 0x8032e77f:
		return offs- 0x348

	if offs >= 0x8032e780 and offs <= 0x8035197f:
		return offs- 0x340

	if offs >= 0x80351980 and offs <= 0x80429563:
		return offs- 0x300

	if offs >= 0x80429564 and offs <= 0x80429d7f:
		return offs- 0x2f8

	if offs >= 0x80429d80 and offs <= 0x806dffff:
		return offs- 0x2e0

	if offs >= 0x806e0000 and offs <= 0x8098a43b:
		return offs+ 0x0

	if offs >= 0x8098a43c and offs <= 0x8098a473:
		return offs+ 0x24

	if offs >= 0x8098a478:
		return offs+ 0x20

	return offs


def fix_offs_ntsc_v2(offs):
	offs = fix_offs_ntsc_v1(offs)

	if offs >= 0x80000000 and offs <= 0x800cf1af:
		return offs+ 0x0

	if offs >= 0x800cf1b0 and offs <= 0x800cf1b3:
		return offs+ 0x4

	if offs >= 0x800cf1b4 and offs <= 0x800cf213:
		return offs+ 0x8

	if offs >= 0x800cf214 and offs <= 0x800cf217:
		return offs+ 0xc

	if offs >= 0x800cf218 and offs <= 0x800cf21f:
		return offs+ 0x18

	if offs >= 0x800cf230 and offs <= 0x800cf237:
		return offs- 0x8

	if offs >= 0x800cf238 and offs <= 0x800cf5f7:
		return offs+ 0x0

	if offs >= 0x800cf5f8 and offs <= 0x800cf5fb:
		return offs+ 0x4

	if offs >= 0x800cf5fc and offs <= 0x800cf64b:
		return offs+ 0x8

	if offs >= 0x800cf64c and offs <= 0x800cf64f:
		return offs+ 0xc

	if offs >= 0x800cf650 and offs <= 0x800cf6f7:
		return offs+ 0x10

	if offs >= 0x800cf6f8 and offs <= 0x800cf6fb:
		return offs+ 0x14

	if offs >= 0x800cf6fc and offs <= 0x800cf703:
		return offs+ 0x20

	if offs >= 0x800cf714 and offs <= 0x800cf71b:
		return offs+ 0x0

	if offs >= 0x800cf71c and offs <= 0x800cf817:
		return offs+ 0x8

	if offs >= 0x800cf820 and offs <= 0x800e0c3b:
		return offs+ 0x0

	if offs >= 0x800e0c40 and offs <= 0x800e0c4f:
		return offs- 0x4

	if offs >= 0x800e0c54 and offs <= 0x800e0c5b:
		return offs- 0x8

	if offs >= 0x800e0c5c and offs <= 0x800e0ceb:
		return offs+ 0x10

	if offs >= 0x800e0cf4 and offs <= 0x800e0d07:
		return offs+ 0x8

	if offs >= 0x800e0d0c and offs <= 0x800e0d1b:
		return offs+ 0x4

	if offs >= 0x800e0d20 and offs <= 0x807683f6:
		return offs+ 0x0

	if offs >= 0x807683f7 and offs <= 0x8076842b:
		return offs+ 0xf

	if offs >= 0x8076842c and offs <= 0x80768462:
		return offs+ 0x1e

	if offs >= 0x80768463 and offs <= 0x8076849b:
		return offs+ 0x2d

	if offs >= 0x8076849c and offs <= 0x8076849f:
		return offs+ 0x3c

	if offs >= 0x807684a0 and offs <= 0x807aaa30:
		return offs+ 0x40

	if offs >= 0x807aaa6c and offs <= 0x8099081f:
		return offs+ 0x10

	if offs >= 0x80990820:
		return offs+ 0x20

	return offs


def fix_offs_jpn_v1(offs):
	if offs >= 0x80000000 and offs <= 0x800b4600:
		return offs+ 0x0

	if offs >= 0x800b4630 and offs <= 0x800b4630:
		return offs- 0x20

	if offs >= 0x800b4660 and offs <= 0x800b466b:
		return offs- 0x4c

	if offs >= 0x800b4670 and offs <= 0x800b46ab:
		return offs- 0x50

	if offs >= 0x800b4734 and offs <= 0x800b475f:
		return offs- 0xd8

	if offs >= 0x800b4760 and offs <= 0x800c8daf:
		return offs- 0xd0

	if offs >= 0x800c8e50 and offs <= 0x800e4c5f:
		return offs- 0x170

	if offs >= 0x800e4c60 and offs <= 0x800e4c63:
		return offs- 0x168

	if offs >= 0x800e4c64 and offs <= 0x800e4c6b:
		return offs- 0x174

	if offs >= 0x800e4c6c and offs <= 0x800e4d6f:
		return offs- 0x170

	if offs >= 0x800e4d94 and offs <= 0x800e4d9b:
		return offs- 0x194

	if offs >= 0x800e4da0 and offs <= 0x800e4ebf:
		return offs- 0x194

	if offs >= 0x800e4ec0 and offs <= 0x8010f1df:
		return offs- 0x190

	if offs >= 0x8010f1ec and offs <= 0x8010f203:
		return offs- 0x19c

	if offs >= 0x8010f234 and offs <= 0x8010f237:
		return offs- 0x1bc

	if offs >= 0x8010f238 and offs <= 0x8010f23b:
		return offs- 0x1c8

	if offs >= 0x8010f23c and offs <= 0x8010f23f:
		return offs- 0x1d0

	if offs >= 0x8010f240 and offs <= 0x8010f243:
		return offs- 0x1cc

	if offs >= 0x8010f244 and offs <= 0x8010f257:
		return offs- 0x1c8

	if offs >= 0x8010f32c and offs <= 0x8010f32f:
		return offs- 0x29c

	if offs >= 0x8010f330 and offs <= 0x8010f333:
		return offs- 0x298

	if offs >= 0x8010f338 and offs <= 0x8010f33f:
		return offs- 0x29c

	if offs >= 0x8010f340 and offs <= 0x8010f347:
		return offs- 0x298

	if offs >= 0x8010f378 and offs <= 0x8010f387:
		return offs- 0x2c8

	if offs >= 0x8010f3ec and offs <= 0x8010f417:
		return offs- 0x32c

	if offs >= 0x8010f41c and offs <= 0x802bb6bf:
		return offs- 0x330

	if offs >= 0x802bb6d0 and offs <= 0x802bb74f:
		return offs- 0x340

	if offs >= 0x802bb860 and offs <= 0x802bbbff:
		return offs- 0x450

	if offs >= 0x802bbc90 and offs <= 0x80317737:
		return offs- 0x4e0

	if offs >= 0x80317750 and offs <= 0x80322ff7:
		return offs- 0x4f8

	if offs >= 0x803230a0 and offs <= 0x803230c3:
		return offs- 0x5a0

	if offs >= 0x80323118 and offs <= 0x8035197f:
		return offs- 0x5e0

	if offs >= 0x80351980 and offs <= 0x80427e5f:
		return offs- 0x580

	if offs >= 0x80427e88 and offs <= 0x8042954b:
		return offs- 0x5a8

	if offs >= 0x80429560 and offs <= 0x80429563:
		return offs- 0x5bc

	if offs >= 0x80429570 and offs <= 0x80429d7f:
		return offs- 0x5c8

	if offs >= 0x80429d80 and offs <= 0x806dffff:
		return offs- 0x5c0

	if offs >= 0x806e0000 and offs <= 0x80779abf:
		return offs+ 0x0

	if offs >= 0x80779b78 and offs <= 0x80779b7f:
		return offs- 0xb8

	if offs >= 0x80779b84 and offs <= 0x80779b93:
		return offs- 0xb8

	if offs >= 0x80779bbc and offs <= 0x80779bcb:
		return offs- 0xe0

	if offs >= 0x80779c1c and offs <= 0x8078891f:
		return offs- 0x130

	if offs >= 0x807889d8 and offs <= 0x807889df:
		return offs- 0x1e8

	if offs >= 0x807889e4 and offs <= 0x807889f3:
		return offs- 0x1e8

	if offs >= 0x80788a1c and offs <= 0x80788a2b:
		return offs- 0x210

	if offs >= 0x80788a7c and offs <= 0x80789eef:
		return offs- 0x260

	if offs >= 0x80789f00 and offs <= 0x808d3b87:
		return offs- 0x270

	if offs >= 0x808d3bd4 and offs <= 0x808d3bd7:
		return offs- 0x2b4

	if offs >= 0x808d3bd8 and offs <= 0x808d3bdb:
		return offs- 0x2bc

	if offs >= 0x808d3bdc and offs <= 0x808d3be3:
		return offs- 0x2b8

	if offs >= 0x808d3be4 and offs <= 0x808d3be7:
		return offs- 0x2ac

	if offs >= 0x808d3be8 and offs <= 0x808d3beb:
		return offs- 0x2b4

	if offs >= 0x808d3bec and offs <= 0x808d3bef:
		return offs- 0x2bc

	if offs >= 0x808d3bf0 and offs <= 0x808d3bf3:
		return offs- 0x2c4

	if offs >= 0x808d3bf4 and offs <= 0x808d3c17:
		return offs- 0x2b8

	if offs >= 0x808d3c20 and offs <= 0x80940cb3:
		return offs- 0x2c0

	if offs >= 0x80940ea0 and offs <= 0x80940ed3:
		return offs- 0x4ac

	if offs >= 0x80940ed8 and offs <= 0x80940f07:
		return offs- 0x4b0

	if offs >= 0x80940f58 and offs <= 0x80943187:
		return offs- 0x4e8

	if offs >= 0x8094318c and offs <= 0x809431ab:
		return offs- 0x4ec

	if offs >= 0x809431b0 and offs <= 0x809431cf:
		return offs- 0x4f0

	if offs >= 0x809431d4 and offs <= 0x809431f3:
		return offs- 0x4f4

	if offs >= 0x809431f8 and offs <= 0x809432b7:
		return offs- 0x4f8

	if offs >= 0x809432c0 and offs <= 0x80944e93:
		return offs- 0x500

	if offs >= 0x80944e98 and offs <= 0x80944eb3:
		return offs- 0x504

	if offs >= 0x80944ec0 and offs <= 0x80944edb:
		return offs- 0x510

	if offs >= 0x80944ee0 and offs <= 0x80944eeb:
		return offs- 0x514

	if offs >= 0x809450ac and offs <= 0x809450c3:
		return offs- 0x6d4

	if offs >= 0x809450c8 and offs <= 0x809450f3:
		return offs- 0x6d8

	if offs >= 0x80945144 and offs <= 0x80945153:
		return offs- 0x714

	if offs >= 0x80945158 and offs <= 0x8098a43b:
		return offs- 0x718

	if offs >= 0x8098a43c and offs <= 0x8098a473:
		return offs- 0x6f4

	if offs >= 0x8098a478 and offs <= 0x809907f7:
		return offs- 0x6f8

	if offs >= 0x80990800:
		return offs- 0x700

	return offs


def fix_offs_jpn_v2(offs):
	offs = fix_offs_jpn_v1(offs)

	if offs >= 0x80000000 and offs <= 0x800cf12f:
		return offs+ 0x0

	if offs >= 0x800cf130 and offs <= 0x800cf133:
		return offs+ 0x4

	if offs >= 0x800cf134 and offs <= 0x800cf193:
		return offs+ 0x8

	if offs >= 0x800cf194 and offs <= 0x800cf197:
		return offs+ 0xc

	if offs >= 0x800cf198 and offs <= 0x800cf19f:
		return offs+ 0x18

	if offs >= 0x800cf1b0 and offs <= 0x800cf1b7:
		return offs- 0x8

	if offs >= 0x800cf1b8 and offs <= 0x800cf577:
		return offs+ 0x0

	if offs >= 0x800cf578 and offs <= 0x800cf57b:
		return offs+ 0x4

	if offs >= 0x800cf57c and offs <= 0x800cf5cb:
		return offs+ 0x8

	if offs >= 0x800cf5cc and offs <= 0x800cf5cf:
		return offs+ 0xc

	if offs >= 0x800cf5d0 and offs <= 0x800cf677:
		return offs+ 0x10

	if offs >= 0x800cf678 and offs <= 0x800cf67b:
		return offs+ 0x14

	if offs >= 0x800cf67c and offs <= 0x800cf683:
		return offs+ 0x20

	if offs >= 0x800cf694 and offs <= 0x800cf69b:
		return offs+ 0x0

	if offs >= 0x800cf69c and offs <= 0x800cf797:
		return offs+ 0x8

	if offs >= 0x800cf7a0 and offs <= 0x800e0bbb:
		return offs+ 0x0

	if offs >= 0x800e0bc0 and offs <= 0x800e0bcf:
		return offs- 0x4

	if offs >= 0x800e0bd4 and offs <= 0x800e0bdb:
		return offs- 0x8

	if offs >= 0x800e0bdc and offs <= 0x800e0c6b:
		return offs+ 0x10

	if offs >= 0x800e0c74 and offs <= 0x800e0c87:
		return offs+ 0x8

	if offs >= 0x800e0c8c and offs <= 0x800e0c9b:
		return offs+ 0x4

	if offs >= 0x800e0ca0 and offs <= 0x807683f6:
		return offs+ 0x0

	if offs >= 0x807683f7 and offs <= 0x8076842b:
		return offs+ 0xf

	if offs >= 0x8076842c and offs <= 0x80768462:
		return offs+ 0x1e

	if offs >= 0x80768463 and offs <= 0x8076849b:
		return offs+ 0x2d

	if offs >= 0x8076849c and offs <= 0x8076849f:
		return offs+ 0x3c

	if offs >= 0x807684a0 and offs <= 0x807aa7c0:
		return offs+ 0x40

	if offs >= 0x807aa7fc and offs <= 0x809900ff:
		return offs+ 0x10

	if offs >= 0x80990100:
		return offs+ 0x20

	return offs


def fix_offs_kor(offs):
	offs = fix_offs_pal_v2(offs)

	if offs >= 0x80000000 and offs <= 0x800122c0:
		return offs+ 0x0

	if offs >= 0x800122c1 and offs <= 0x800122eb:
		return offs+ 0x14

	if offs >= 0x800122f0 and offs <= 0x800122f7:
		return offs+ 0x14

	if offs >= 0x80012300 and offs <= 0x8001230b:
		return offs+ 0x28

	if offs >= 0x8001230c and offs <= 0x8001230f:
		return offs+ 0x2c

	if offs >= 0x80012314 and offs <= 0x8001231f:
		return offs+ 0x3c

	if offs >= 0x80012320 and offs <= 0x80012337:
		return offs+ 0x40

	if offs >= 0x80012338 and offs <= 0x8001233f:
		return offs+ 0x78

	if offs >= 0x80012364 and offs <= 0x80012397:
		return offs+ 0x54

	if offs >= 0x80012398 and offs <= 0x8001239f:
		return offs+ 0x58

	if offs >= 0x800123a4 and offs <= 0x800123bb:
		return offs+ 0x54

	if offs >= 0x800123c0 and offs <= 0x800123eb:
		return offs+ 0x50

	if offs >= 0x800123ec and offs <= 0x8001244f:
		return offs+ 0x64

	if offs >= 0x80012450 and offs <= 0x8004dea7:
		return offs+ 0x70

	if offs >= 0x8004deac and offs <= 0x8004deb7:
		return offs+ 0x6c

	if offs >= 0x8004dec0 and offs <= 0x8004dedf:
		return offs+ 0x68

	if offs >= 0x8004dee0 and offs <= 0x8004df37:
		return offs+ 0x70

	if offs >= 0x8004df3c and offs <= 0x8004df47:
		return offs+ 0x6c

	if offs >= 0x8004df50 and offs <= 0x8004df6f:
		return offs+ 0x68

	if offs >= 0x8004df70 and offs <= 0x80050e5f:
		return offs+ 0x70

	if offs >= 0x80050e60 and offs <= 0x80052f03:
		return offs+ 0xd0

	if offs >= 0x80052f24 and offs <= 0x8005c453:
		return offs+ 0xe0

	if offs >= 0x8005c454 and offs <= 0x8005c457:
		return offs+ 0xe8

	if offs >= 0x8005c458 and offs <= 0x8005c48b:
		return offs+ 0xf8

	if offs >= 0x8005c48c and offs <= 0x8005c497:
		return offs+ 0xfc

	if offs >= 0x8005c498 and offs <= 0x8005c6c7:
		return offs+ 0x108

	if offs >= 0x8005c6d0 and offs <= 0x8005f813:
		return offs+ 0x100

	if offs >= 0x8005f850 and offs <= 0x8005f877:
		return offs+ 0xc8

	if offs >= 0x8005f880 and offs <= 0x8009624f:
		return offs+ 0x140

	if offs >= 0x80096250 and offs <= 0x80096253:
		return offs+ 0x150

	if offs >= 0x80096254 and offs <= 0x8009625b:
		return offs+ 0x13c

	if offs >= 0x8009625c and offs <= 0x8009626f:
		return offs+ 0x148

	if offs >= 0x80096278 and offs <= 0x8009628f:
		return offs+ 0x17c

	if offs >= 0x80096290 and offs <= 0x800b45ff:
		return offs+ 0x180

	if offs >= 0x800b4600 and offs <= 0x800b4600:
		return offs+ 0x190

	if offs >= 0x800b4630 and offs <= 0x800b4630:
		return offs+ 0x170

	if offs >= 0x800b4670 and offs <= 0x800b46ab:
		return offs+ 0x140

	if offs >= 0x800b4734 and offs <= 0x800b475f:
		return offs+ 0xb8

	if offs >= 0x800b4760 and offs <= 0x800c8daf:
		return offs+ 0xc0

	if offs >= 0x800c8e50 and offs <= 0x800e4c5f:
		return offs+ 0x20

	if offs >= 0x800e4c60 and offs <= 0x800e4c63:
		return offs+ 0x28

	if offs >= 0x800e4c64 and offs <= 0x800e4c6b:
		return offs+ 0x1c

	if offs >= 0x800e4c6c and offs <= 0x800e4d6f:
		return offs+ 0x20

	if offs >= 0x800e4d94 and offs <= 0x800e4d9b:
		return offs- 0x4

	if offs >= 0x800e4da0 and offs <= 0x800e4ebf:
		return offs- 0x4

	if offs >= 0x800e4ec0 and offs <= 0x800f794f:
		return offs+ 0x0

	if offs >= 0x800f7950 and offs <= 0x800f79bf:
		return offs+ 0xc

	if offs >= 0x800f79c0 and offs <= 0x800fd5eb:
		return offs+ 0x10

	if offs >= 0x800fd5ec and offs <= 0x800fd60b:
		return offs+ 0x44

	if offs >= 0x800fd610 and offs <= 0x801011bf:
		return offs+ 0x40

	if offs >= 0x801011c0 and offs <= 0x8010127f:
		return offs+ 0xb0

	if offs >= 0x80101280 and offs <= 0x80106f37:
		return offs+ 0x100

	if offs >= 0x80106f38 and offs <= 0x80106f6f:
		return offs+ 0x108

	if offs >= 0x80106f70 and offs <= 0x80106fbb:
		return offs+ 0x110

	if offs >= 0x80106fbc and offs <= 0x80106fbf:
		return offs+ 0x114

	if offs >= 0x80106fc0 and offs <= 0x80106fc3:
		return offs+ 0x12c

	if offs >= 0x80106fc4 and offs <= 0x80106fc7:
		return offs+ 0x11c

	if offs >= 0x80106fc8 and offs <= 0x80106fe7:
		return offs+ 0x128

	if offs >= 0x80106ff0 and offs <= 0x80107047:
		return offs+ 0x120

	if offs >= 0x80107048 and offs <= 0x80107053:
		return offs+ 0x124

	if offs >= 0x80107074 and offs <= 0x80107077:
		return offs+ 0x114

	if offs >= 0x80107078 and offs <= 0x8010708f:
		return offs+ 0x118

	if offs >= 0x80107090 and offs <= 0x80107090:
		return offs+ 0x120

	if offs >= 0x80107091 and offs <= 0x8010709f:
		return offs+ 0x144

	if offs >= 0x801070a4 and offs <= 0x801070ab:
		return offs+ 0x174

	if offs >= 0x801070b0 and offs <= 0x801070b0:
		return offs+ 0x170

	if offs >= 0x801070b1 and offs <= 0x801070b3:
		return offs+ 0x188

	if offs >= 0x801070b4 and offs <= 0x801070b7:
		return offs+ 0x194

	if offs >= 0x801070b8 and offs <= 0x801070bb:
		return offs+ 0x188

	if offs >= 0x801070bc and offs <= 0x801070bf:
		return offs+ 0x194

	if offs >= 0x801070c0 and offs <= 0x801070c3:
		return offs+ 0x18c

	if offs >= 0x801070c8 and offs <= 0x801070cf:
		return offs+ 0x1c0

	if offs >= 0x801070d0 and offs <= 0x8010710b:
		return offs+ 0x1f0

	if offs >= 0x8010710c and offs <= 0x80107113:
		return offs+ 0x1fc

	if offs >= 0x80107114 and offs <= 0x801071f3:
		return offs+ 0x210

	if offs >= 0x801071f4 and offs <= 0x8010727f:
		return offs+ 0x21c

	if offs >= 0x80107280 and offs <= 0x80107317:
		return offs+ 0x350

	if offs >= 0x80107318 and offs <= 0x8010733b:
		return offs+ 0x35c

	if offs >= 0x8010733c and offs <= 0x801073bf:
		return offs+ 0x368

	if offs >= 0x801073c0 and offs <= 0x801074ef:
		return offs+ 0x4e0

	if offs >= 0x801074f0 and offs <= 0x801074f7:
		return offs+ 0x4e4

	if offs >= 0x801074f8 and offs <= 0x801074fb:
		return offs+ 0x4d8

	if offs >= 0x801074fc and offs <= 0x80107503:
		return offs+ 0x4e0

	if offs >= 0x80107504 and offs <= 0x8010751b:
		return offs+ 0x4e4

	if offs >= 0x80107520 and offs <= 0x801076c7:
		return offs+ 0x4e0

	if offs >= 0x801076c8 and offs <= 0x80107707:
		return offs+ 0x4e4

	if offs >= 0x80107708 and offs <= 0x80107787:
		return offs+ 0x4f0

	if offs >= 0x80107788 and offs <= 0x801077b3:
		return offs+ 0x4fc

	if offs >= 0x801077c0 and offs <= 0x801079f3:
		return offs+ 0x4f0

	if offs >= 0x801079f4 and offs <= 0x80107b5b:
		return offs+ 0x520

	if offs >= 0x80107b60 and offs <= 0x80107c27:
		return offs+ 0x520

	if offs >= 0x80107c28 and offs <= 0x80107c5f:
		return offs+ 0x524

	if offs >= 0x80107c60 and offs <= 0x80107c63:
		return offs+ 0x530

	if offs >= 0x80107c64 and offs <= 0x80107c67:
		return offs+ 0x60c

	if offs >= 0x80107c68 and offs <= 0x80107c6b:
		return offs+ 0x62c

	if offs >= 0x80107c6c and offs <= 0x80107c6f:
		return offs+ 0x620

	if offs >= 0x80107c70 and offs <= 0x80107cef:
		return offs+ 0x528

	if offs >= 0x80107cf0 and offs <= 0x80107d27:
		return offs+ 0x530

	if offs >= 0x80107d28 and offs <= 0x80107d3b:
		return offs+ 0x534

	if offs >= 0x80107d3c and offs <= 0x80107d53:
		return offs+ 0x538

	if offs >= 0x80107d54 and offs <= 0x80107d57:
		return offs+ 0x430

	if offs >= 0x80107d58 and offs <= 0x80107d5b:
		return offs+ 0x43c

	if offs >= 0x80107d5c and offs <= 0x80107d5f:
		return offs+ 0x534

	if offs >= 0x80107d60 and offs <= 0x80107d77:
		return offs+ 0x538

	if offs >= 0x80107d80 and offs <= 0x80107e83:
		return offs+ 0x530

	if offs >= 0x80107e84 and offs <= 0x80107fb3:
		return offs+ 0x538

	if offs >= 0x80107fb4 and offs <= 0x80107fcf:
		return offs+ 0x544

	if offs >= 0x80107fd0 and offs <= 0x8010f1b3:
		return offs+ 0x550

	if offs >= 0x8010f1b4 and offs <= 0x8010f1b7:
		return offs+ 0x570

	if offs >= 0x8010f1b8 and offs <= 0x8010f1bb:
		return offs+ 0x550

	if offs >= 0x8010f1bc and offs <= 0x8010f1cf:
		return offs+ 0x56c

	if offs >= 0x8010f1d0 and offs <= 0x8010f1df:
		return offs+ 0x570

	if offs >= 0x8010f1ec and offs <= 0x8010f203:
		return offs+ 0x564

	if offs >= 0x8010f234 and offs <= 0x8010f237:
		return offs+ 0x544

	if offs >= 0x8010f238 and offs <= 0x8010f23b:
		return offs+ 0x538

	if offs >= 0x8010f23c and offs <= 0x8010f23f:
		return offs+ 0x530

	if offs >= 0x8010f240 and offs <= 0x8010f243:
		return offs+ 0x534

	if offs >= 0x8010f244 and offs <= 0x8010f257:
		return offs+ 0x538

	if offs >= 0x8010f32c and offs <= 0x8010f32f:
		return offs+ 0x464

	if offs >= 0x8010f330 and offs <= 0x8010f333:
		return offs+ 0x468

	if offs >= 0x8010f338 and offs <= 0x8010f33f:
		return offs+ 0x464

	if offs >= 0x8010f340 and offs <= 0x8010f347:
		return offs+ 0x468

	if offs >= 0x8010f378 and offs <= 0x8010f387:
		return offs+ 0x438

	if offs >= 0x8010f3ec and offs <= 0x8010f417:
		return offs+ 0x3d4

	if offs >= 0x8010f41c and offs <= 0x80150e77:
		return offs+ 0x3d0

	if offs >= 0x80150e80 and offs <= 0x80150e83:
		return offs+ 0x3c8

	if offs >= 0x80150e90 and offs <= 0x80150ebb:
		return offs+ 0x3c0

	if offs >= 0x80150ec4 and offs <= 0x80150ec7:
		return offs+ 0x3b8

	if offs >= 0x80150ed4 and offs <= 0x8015140f:
		return offs+ 0x3b0

	if offs >= 0x80151410 and offs <= 0x8015145f:
		return offs+ 0x3c4

	if offs >= 0x80151460 and offs <= 0x80152413:
		return offs+ 0x3d0

	if offs >= 0x80152414 and offs <= 0x8015241f:
		return offs+ 0x3dc

	if offs >= 0x80152424 and offs <= 0x80158837:
		return offs+ 0x3e0

	if offs >= 0x8015883c and offs <= 0x801589cf:
		return offs+ 0x3dc

	if offs >= 0x801589d0 and offs <= 0x801590c3:
		return offs+ 0x3e0

	if offs >= 0x801590c4 and offs <= 0x801590eb:
		return offs+ 0x3ec

	if offs >= 0x801590ec and offs <= 0x8015912f:
		return offs+ 0x3f0

	if offs >= 0x80159130 and offs <= 0x8015918f:
		return offs+ 0x3f4

	if offs >= 0x80159190 and offs <= 0x8015acdf:
		return offs+ 0x400

	if offs >= 0x8015ace0 and offs <= 0x8015ace3:
		return offs+ 0x410

	if offs >= 0x8015ace4 and offs <= 0x8015ace7:
		return offs+ 0x3fc

	if offs >= 0x8015ace8 and offs <= 0x8015acef:
		return offs+ 0x400

	if offs >= 0x8015acf0 and offs <= 0x8015acf3:
		return offs+ 0x40c

	if offs >= 0x8015acf4 and offs <= 0x8015acfb:
		return offs+ 0x400

	if offs >= 0x8015acfc and offs <= 0x8015ad2b:
		return offs+ 0x404

	if offs >= 0x8015ad2c and offs <= 0x8015ad2f:
		return offs+ 0x3b8

	if offs >= 0x8015ad30 and offs <= 0x802bb6bf:
		return offs+ 0x400

	if offs >= 0x802bb6d0 and offs <= 0x802bb74f:
		return offs+ 0x3f0

	if offs >= 0x802bb860 and offs <= 0x802bbbff:
		return offs+ 0x2e0

	if offs >= 0x802bbc90 and offs <= 0x802e467c:
		return offs+ 0x250

	if offs >= 0x802e4680 and offs <= 0x802edcd7:
		return offs+ 0x348

	if offs >= 0x802edce0 and offs <= 0x802f4b1f:
		return offs+ 0x340

	if offs >= 0x802f4b20 and offs <= 0x802f4b7f:
		return offs+ 0x348

	if offs >= 0x802f4b80 and offs <= 0x802f4bdf:
		return offs+ 0x350

	if offs >= 0x802f4be0 and offs <= 0x802f5d43:
		return offs+ 0x358

	if offs >= 0x802f5d44 and offs <= 0x802fd29f:
		return offs+ 0xc538

	if offs >= 0x802fd2a0 and offs <= 0x80317737:
		return offs+ 0xc540

	if offs >= 0x80317750 and offs <= 0x8032080f:
		return offs+ 0xc528

	if offs >= 0x80320810 and offs <= 0x8032164f:
		return offs+ 0xc570

	if offs >= 0x80321650 and offs <= 0x80321f07:
		return offs+ 0xc578

	if offs >= 0x80321f08 and offs <= 0x80321f17:
		return offs+ 0xc57c

	if offs >= 0x80321f18 and offs <= 0x80321f33:
		return offs+ 0xc588

	if offs >= 0x80321f38 and offs <= 0x80321f6f:
		return offs+ 0xc584

	if offs >= 0x80321f70 and offs <= 0x80321f97:
		return offs+ 0xc588

	if offs >= 0x80321f98 and offs <= 0x80321fe7:
		return offs+ 0xc58c

	if offs >= 0x80321fe8 and offs <= 0x80322003:
		return offs+ 0xc594

	if offs >= 0x80322004 and offs <= 0x8032204f:
		return offs+ 0xc5b4

	if offs >= 0x80322050 and offs <= 0x8032206b:
		return offs+ 0xc600

	if offs >= 0x8032206c and offs <= 0x803220bf:
		return offs+ 0xc61c

	if offs >= 0x803220c0 and offs <= 0x803220df:
		return offs+ 0xc670

	if offs >= 0x803220e0 and offs <= 0x80322147:
		return offs+ 0xc690

	if offs >= 0x80322148 and offs <= 0x803221a7:
		return offs+ 0xc6f4

	if offs >= 0x803221a8 and offs <= 0x803221c3:
		return offs+ 0xc754

	if offs >= 0x803221c4 and offs <= 0x80322233:
		return offs+ 0xc76c

	if offs >= 0x80322234 and offs <= 0x803222a3:
		return offs+ 0xc7d8

	if offs >= 0x803222a4 and offs <= 0x803222c3:
		return offs+ 0xc848

	if offs >= 0x803222c4 and offs <= 0x80322337:
		return offs+ 0xc86c

	if offs >= 0x80322338 and offs <= 0x80322353:
		return offs+ 0xc8e0

	if offs >= 0x80322354 and offs <= 0x803223c7:
		return offs+ 0xc8fc

	if offs >= 0x803223c8 and offs <= 0x803223e7:
		return offs+ 0xc968

	if offs >= 0x803223e8 and offs <= 0x80322447:
		return offs+ 0xc988

	if offs >= 0x80322448 and offs <= 0x803224d7:
		return offs+ 0xcab8

	if offs >= 0x803224d8 and offs <= 0x803224e3:
		return offs+ 0xcad0

	if offs >= 0x803224f0 and offs <= 0x80322ff7:
		return offs+ 0xcac8

	if offs >= 0x803230a0 and offs <= 0x803230c3:
		return offs+ 0xca20

	if offs >= 0x80323118 and offs <= 0x803279cf:
		return offs+ 0xc9e0

	if offs >= 0x803279d0 and offs <= 0x8032e777:
		return offs+ 0xc9e8

	if offs >= 0x8032e780 and offs <= 0x8035197f:
		return offs+ 0xc9e0

	if offs >= 0x80351980 and offs <= 0x80427e5f:
		return offs+ 0xca00

	if offs >= 0x80427e88 and offs <= 0x8042823f:
		return offs+ 0xc9d8

	if offs >= 0x80428244 and offs <= 0x80428253:
		return offs+ 0xc9d4

	if offs >= 0x80428258 and offs <= 0x80429427:
		return offs+ 0xc9d0

	if offs >= 0x80429428 and offs <= 0x80429497:
		return offs+ 0xc9d8

	if offs >= 0x80429498 and offs <= 0x804294df:
		return offs+ 0xc9e0

	if offs >= 0x804294e0 and offs <= 0x804294e3:
		return offs+ 0xc9e4

	if offs >= 0x804294e8 and offs <= 0x8042954b:
		return offs+ 0xc9e0

	if offs >= 0x80429560 and offs <= 0x80429563:
		return offs+ 0xc9cc

	if offs >= 0x80429570 and offs <= 0x8042d537:
		return offs+ 0xc9c0

	if offs >= 0x8042d538 and offs <= 0x8042d547:
		return offs+ 0xc9c8

	if offs >= 0x8042d548 and offs <= 0x8042d54b:
		return offs+ 0xc9cc

	if offs >= 0x8042d550 and offs <= 0x8042f427:
		return offs+ 0xc9c8

	if offs >= 0x8042f430 and offs <= 0x806d363f:
		return offs+ 0xc9c0

	if offs >= 0x806e0000 and offs <= 0x807683f2:
		return offs+ 0x0

	if offs >= 0x80768406 and offs <= 0x80768436:
		return offs- 0x13

	if offs >= 0x8076844a and offs <= 0x8076847c:
		return offs- 0x26

	if offs >= 0x80768490 and offs <= 0x807684c4:
		return offs- 0x39

	if offs >= 0x807684d8 and offs <= 0x807684df:
		return offs- 0x4c

	if offs >= 0x807684e0 and offs <= 0x8076b27f:
		return offs- 0x40

	if offs >= 0x8076b280 and offs <= 0x8076ca93:
		return offs- 0x38

	if offs >= 0x8076ca94 and offs <= 0x8076d45f:
		return offs- 0x28

	if offs >= 0x8076d4a0 and offs <= 0x8076dd7c:
		return offs- 0x40

	if offs >= 0x8076dd80 and offs <= 0x8076dd83:
		return offs- 0x28

	if offs >= 0x8076dd88 and offs <= 0x8076dd8b:
		return offs- 0x2c

	if offs >= 0x8076dd8c and offs <= 0x8076dd8f:
		return offs- 0x28

	if offs >= 0x8076dd90 and offs <= 0x8076dd93:
		return offs- 0x30

	if offs >= 0x8076dd94 and offs <= 0x8076dd97:
		return offs- 0x28

	if offs >= 0x8076dd98 and offs <= 0x8076dd9b:
		return offs- 0x30

	if offs >= 0x8076dd9c and offs <= 0x8076ddcf:
		return offs- 0x2c

	if offs >= 0x8076ddd0 and offs <= 0x8076ddd3:
		return offs- 0x28

	if offs >= 0x8076ddd4 and offs <= 0x8076df1f:
		return offs- 0x24

	if offs >= 0x8076df20 and offs <= 0x80779afc:
		return offs- 0x20

	if offs >= 0x80779bb8 and offs <= 0x80779bd3:
		return offs- 0xd8

	if offs >= 0x80779bfc and offs <= 0x80779c0b:
		return offs- 0x100

	if offs >= 0x80779c5c and offs <= 0x8078895f:
		return offs- 0x150

	if offs >= 0x80788a18 and offs <= 0x80788a33:
		return offs- 0x208

	if offs >= 0x80788a5c and offs <= 0x80788a6b:
		return offs- 0x230

	if offs >= 0x80788abc and offs <= 0x8079d57f:
		return offs- 0x280

	if offs >= 0x8079d580 and offs <= 0x8079d8f3:
		return offs+ 0x4090

	if offs >= 0x8079d8f4 and offs <= 0x8079d9bb:
		return offs+ 0x4094

	if offs >= 0x8079d9bc and offs <= 0x8079d9eb:
		return offs+ 0x40b0

	if offs >= 0x8079d9ec and offs <= 0x8079e1db:
		return offs+ 0x40c0

	if offs >= 0x8079e1dc and offs <= 0x8079e2f3:
		return offs+ 0x40d0

	if offs >= 0x8079e2f8 and offs <= 0x8079e2fb:
		return offs+ 0x40cc

	if offs >= 0x8079e318 and offs <= 0x8079e387:
		return offs+ 0x40dc

	if offs >= 0x8079e3a8 and offs <= 0x8079e3cb:
		return offs+ 0x40bc

	if offs >= 0x8079e3d0 and offs <= 0x8079e3d3:
		return offs+ 0x40b8

	if offs >= 0x8079e3f0 and offs <= 0x8079e45f:
		return offs+ 0x40c8

	if offs >= 0x8079e480 and offs <= 0x8079e497:
		return offs+ 0x40a8

	if offs >= 0x8079e4a0 and offs <= 0x8079eb23:
		return offs+ 0x40a0

	if offs >= 0x8079eb24 and offs <= 0x8079eb63:
		return offs+ 0x40b0

	if offs >= 0x8079eb64 and offs <= 0x8079ebdb:
		return offs+ 0x40c4

	if offs >= 0x8079ebe0 and offs <= 0x807a124f:
		return offs+ 0x40c0

	if offs >= 0x807a1250 and offs <= 0x807a1253:
		return offs+ 0x40dc

	if offs >= 0x807a1254 and offs <= 0x807a1257:
		return offs+ 0x40c0

	if offs >= 0x807a1258 and offs <= 0x807a125b:
		return offs+ 0x40d8

	if offs >= 0x807a125c and offs <= 0x807a125f:
		return offs+ 0x40b4

	if offs >= 0x807a1260 and offs <= 0x807a1273:
		return offs+ 0x40b8

	if offs >= 0x807a1274 and offs <= 0x807a43af:
		return offs+ 0x40c0

	if offs >= 0x807a43b0 and offs <= 0x807a43b3:
		return offs+ 0x40c4

	if offs >= 0x807a43b8 and offs <= 0x807a43bb:
		return offs+ 0x40b8

	if offs >= 0x807a43bc and offs <= 0x807a44bf:
		return offs+ 0x40bc

	if offs >= 0x807a44c0 and offs <= 0x807a7b63:
		return offs+ 0x40c0

	if offs >= 0x807a7b64 and offs <= 0x807a7b67:
		return offs+ 0x40c4

	if offs >= 0x807a7b6c and offs <= 0x807a7b6f:
		return offs+ 0x40b8

	if offs >= 0x807a7b70 and offs <= 0x807a7c1f:
		return offs+ 0x40bc

	if offs >= 0x807a7c20 and offs <= 0x80817390:
		return offs+ 0x40c0

	if offs >= 0x80817391 and offs <= 0x80817393:
		return offs+ 0x40c8

	if offs >= 0x80817394 and offs <= 0x80817397:
		return offs+ 0x40e0

	if offs >= 0x80817398 and offs <= 0x8081739b:
		return offs+ 0x40cc

	if offs >= 0x8081739c and offs <= 0x8081739f:
		return offs+ 0x40d4

	if offs >= 0x808173a0 and offs <= 0x808173a7:
		return offs+ 0x40c8

	if offs >= 0x808173a8 and offs <= 0x808173b3:
		return offs+ 0x40d0

	if offs >= 0x808173b4 and offs <= 0x808173b7:
		return offs+ 0x40a8

	if offs >= 0x808173b8 and offs <= 0x808173eb:
		return offs+ 0x40cc

	if offs >= 0x808173ec and offs <= 0x808173ef:
		return offs+ 0x40e0

	if offs >= 0x808173f0 and offs <= 0x808173f7:
		return offs+ 0x40e8

	if offs >= 0x80817400 and offs <= 0x808174db:
		return offs+ 0x40e0

	if offs >= 0x808174dc and offs <= 0x8081752f:
		return offs+ 0x40ec

	if offs >= 0x80817530 and offs <= 0x80826ddf:
		return offs+ 0x40f0

	if offs >= 0x80826e90 and offs <= 0x80827003:
		return offs+ 0x4210

	if offs >= 0x80827004 and offs <= 0x80827007:
		return offs+ 0x4214

	if offs >= 0x80827008 and offs <= 0x8082700f:
		return offs+ 0x4218

	if offs >= 0x80827014 and offs <= 0x80827023:
		return offs+ 0x4228

	if offs >= 0x80827028 and offs <= 0x80827043:
		return offs+ 0x4224

	if offs >= 0x80827048 and offs <= 0x80827227:
		return offs+ 0x4220

	if offs >= 0x80827228 and offs <= 0x8082729f:
		return offs+ 0x4228

	if offs >= 0x808272a0 and offs <= 0x8086e98f:
		return offs+ 0x4230

	if offs >= 0x8086e990 and offs <= 0x8086e9db:
		return offs+ 0x4244

	if offs >= 0x8086e9e0 and offs <= 0x8086eabb:
		return offs+ 0x4240

	if offs >= 0x8086eabc and offs <= 0x8086eabf:
		return offs+ 0x4244

	if offs >= 0x8086eac0 and offs <= 0x8086eac3:
		return offs+ 0x423c

	if offs >= 0x8086eac4 and offs <= 0x8086eb7b:
		return offs+ 0x4240

	if offs >= 0x8086eb7c and offs <= 0x8086eb7f:
		return offs+ 0x4244

	if offs >= 0x8086eb80 and offs <= 0x8086eb83:
		return offs+ 0x4260

	if offs >= 0x8086eb84 and offs <= 0x8086eb87:
		return offs+ 0x4268

	if offs >= 0x8086eb88 and offs <= 0x8086eb8b:
		return offs+ 0x4260

	if offs >= 0x8086eb8c and offs <= 0x8086ebbf:
		return offs+ 0x4264

	if offs >= 0x8086ebc0 and offs <= 0x808d3b97:
		return offs+ 0x4270

	if offs >= 0x808d3be4 and offs <= 0x808d3be7:
		return offs+ 0x422c

	if offs >= 0x808d3be8 and offs <= 0x808d3beb:
		return offs+ 0x4224

	if offs >= 0x808d3bec and offs <= 0x808d3bef:
		return offs+ 0x4228

	if offs >= 0x808d3bf8 and offs <= 0x808d3bfb:
		return offs+ 0x422c

	if offs >= 0x808d3bfc and offs <= 0x808d3bff:
		return offs+ 0x4224

	if offs >= 0x808d3c00 and offs <= 0x808d3c03:
		return offs+ 0x421c

	if offs >= 0x808d3c04 and offs <= 0x808d3c27:
		return offs+ 0x4228

	if offs >= 0x808d3c30 and offs <= 0x808ef2df:
		return offs+ 0x4220

	if offs >= 0x808ef310 and offs <= 0x808fb94f:
		return offs+ 0x41f0

	if offs >= 0x808fb950 and offs <= 0x808fb95b:
		return offs+ 0x41fc

	if offs >= 0x808fb994 and offs <= 0x808fbcef:
		return offs+ 0x41f8

	if offs >= 0x808fbcf8 and offs <= 0x808fbd0f:
		return offs+ 0x420c

	if offs >= 0x808fbd10 and offs <= 0x808fbfdf:
		return offs+ 0x4210

	if offs >= 0x808fbfe0 and offs <= 0x80902a87:
		return offs+ 0x4250

	if offs >= 0x80902aa0 and offs <= 0x80902acf:
		return offs+ 0x423c

	if offs >= 0x80902ad0 and offs <= 0x8090947f:
		return offs+ 0x4240

	if offs >= 0x80909510 and offs <= 0x8091f15f:
		return offs+ 0x41b0

	if offs >= 0x8091f160 and offs <= 0x8091f167:
		return offs+ 0x41b4

	if offs >= 0x8091f168 and offs <= 0x8091f17f:
		return offs+ 0x41b8

	if offs >= 0x8091f180 and offs <= 0x8091f257:
		return offs+ 0x41c0

	if offs >= 0x8091f258 and offs <= 0x8091f27b:
		return offs+ 0x41d4

	if offs >= 0x8091f280 and offs <= 0x809337eb:
		return offs+ 0x41d0

	if offs >= 0x809337ec and offs <= 0x8093520f:
		return offs+ 0x41d8

	if offs >= 0x80935210 and offs <= 0x809382cf:
		return offs+ 0x42f0

	if offs >= 0x809382e0 and offs <= 0x80940c77:
		return offs+ 0x4300

	if offs >= 0x80940c7c and offs <= 0x80940c9b:
		return offs+ 0x42fc

	if offs >= 0x80940ca0 and offs <= 0x80940cbf:
		return offs+ 0x42f8

	if offs >= 0x80940cc4 and offs <= 0x80940ccf:
		return offs+ 0x42f4

	if offs >= 0x80940eb0 and offs <= 0x80940ee3:
		return offs+ 0x4114

	if offs >= 0x80940ee8 and offs <= 0x80940f17:
		return offs+ 0x4110

	if offs >= 0x80940f68 and offs <= 0x80944ea3:
		return offs+ 0x40d8

	if offs >= 0x80944ea8 and offs <= 0x80944ec7:
		return offs+ 0x40d4

	if offs >= 0x80944ed0 and offs <= 0x80944efb:
		return offs+ 0x40cc

	if offs >= 0x809450bc and offs <= 0x809450d3:
		return offs+ 0x3f0c

	if offs >= 0x809450d8 and offs <= 0x80945103:
		return offs+ 0x3f08

	if offs >= 0x80945154 and offs <= 0x809494a7:
		return offs+ 0x3ed0

	if offs >= 0x809494a8 and offs <= 0x8094978f:
		return offs+ 0x3edc

	if offs >= 0x80949790 and offs <= 0x8094a387:
		return offs+ 0x3ee0

	if offs >= 0x8094a388 and offs <= 0x8094a3bb:
		return offs+ 0x5090

	if offs >= 0x8094a3bc and offs <= 0x8094a443:
		return offs+ 0x5094

	if offs >= 0x8094a444 and offs <= 0x8094a46f:
		return offs+ 0x5098

	if offs >= 0x8094a470 and offs <= 0x8094a49b:
		return offs+ 0x509c

	if offs >= 0x8094a4a0 and offs <= 0x8094a5f3:
		return offs+ 0x5098

	if offs >= 0x8094a5f8 and offs <= 0x8094a617:
		return offs+ 0x50a4

	if offs >= 0x8094a618 and offs <= 0x8094c0d7:
		return offs+ 0x50a8

	if offs >= 0x8094c0d8 and offs <= 0x8094c123:
		return offs+ 0x50b0

	if offs >= 0x8094c124 and offs <= 0x8094c14b:
		return offs+ 0x50b4

	if offs >= 0x8094c150 and offs <= 0x8094c177:
		return offs+ 0x50b0

	if offs >= 0x8094c178 and offs <= 0x8094c1a3:
		return offs+ 0x50b4

	if offs >= 0x8094c1a8 and offs <= 0x8094cabb:
		return offs+ 0x50b0

	if offs >= 0x8094cabc and offs <= 0x8094d5cb:
		return offs+ 0x50b8

	if offs >= 0x8094d5cc and offs <= 0x8098a37b:
		return offs+ 0x50c0

	if offs >= 0x8098a398 and offs <= 0x8098a3b3:
		return offs+ 0x50a4

	if offs >= 0x8098a488 and offs <= 0x8099080f:
		return offs+ 0x4fd0

	if offs >= 0x80990820 and offs <= 0x80994317:
		return offs+ 0x4fc0

	if offs >= 0x80994318 and offs <= 0x80a0a57f:
		return offs+ 0x54e0

	if offs >= 0x80a0a580 and offs <= 0x80a0a5a7:
		return offs+ 0x54e4

	if offs >= 0x80a0a5b4 and offs <= 0x80a0a5ef:
		return offs+ 0x54e8

	if offs >= 0x80a0a5f0 and offs <= 0x80a0a5ff:
		return offs+ 0x54ec

	if offs >= 0x80a0a600 and offs <= 0x80a0a60f:
		return offs+ 0x54f0

	if offs >= 0x80a0a610 and offs <= 0x80a0a633:
		return offs+ 0x54f8

	if offs >= 0x80a0a63c and offs <= 0x80a0a63f:
		return offs+ 0x54fc

	if offs >= 0x80a0a640 and offs <= 0x80a0a643:
		return offs+ 0x5504

	if offs >= 0x80a0a644 and offs <= 0x80a0a647:
		return offs+ 0x54fc

	if offs >= 0x80a0a648 and offs <= 0x80a0a64b:
		return offs+ 0x54f4

	if offs >= 0x80a0a64c and offs <= 0x80a0a67f:
		return offs+ 0x54fc

	if offs >= 0x80a0a680 and offs <= 0x80a0b1c3:
		return offs+ 0x5500

	if offs >= 0x80a0b1c4 and offs <= 0x80a0b1c7:
		return offs+ 0x5578

	if offs >= 0x80a0b1c8 and offs <= 0x80a0b1cb:
		return offs+ 0x5500

	if offs >= 0x80a0b1cc and offs <= 0x80a0b50f:
		return offs+ 0x5574

	if offs >= 0x80a0b510 and offs <= 0x80a38ee0:
		return offs+ 0x5580

	if offs >= 0x80a38ee1 and offs <= 0x80a38ee3:
		return offs+ 0x55a4

	if offs >= 0x80a38ee4 and offs <= 0x80a38eef:
		return offs+ 0x55ac

	if offs >= 0x80a38ef0 and offs <= 0x80b1143f:
		return offs+ 0x55b0

	if offs >= 0x80b11440 and offs <= 0x80b304fb:
		return offs+ 0x55c0

	if offs >= 0x80b304fc and offs <= 0x80b30513:
		return offs+ 0x55cc

	if offs >= 0x80b3051c and offs <= 0x80b3051f:
		return offs+ 0x55c8

	if offs >= 0x80b30520 and offs <= 0x80b30523:
		return offs+ 0x55dc

	if offs >= 0x80b30524 and offs <= 0x80b30527:
		return offs+ 0x55d0

	if offs >= 0x80b30528 and offs <= 0x80b3052b:
		return offs+ 0x55d8

	if offs >= 0x80b3052c and offs <= 0x80b3052f:
		return offs+ 0x55cc

	if offs >= 0x80b30530 and offs <= 0x80b30533:
		return offs+ 0x55bc

	if offs >= 0x80b30534 and offs <= 0x80b30537:
		return offs+ 0x55d8

	if offs >= 0x80b30538 and offs <= 0x80b3053f:
		return offs+ 0x55cc

	if offs >= 0x80b30540 and offs <= 0x80b30543:
		return offs+ 0x55d4

	if offs >= 0x80b30544 and offs <= 0x80b30547:
		return offs+ 0x55cc

	if offs >= 0x80b30548 and offs <= 0x80b3054b:
		return offs+ 0x55d0

	if offs >= 0x80b3054c and offs <= 0x80b3054f:
		return offs+ 0x55e8

	if offs >= 0x80b30550 and offs <= 0x80b3055f:
		return offs+ 0x55cc

	if offs >= 0x80b30560 and offs <= 0x80b30563:
		return offs+ 0x55dc

	if offs >= 0x80b30564 and offs <= 0x80b3056b:
		return offs+ 0x55c8

	if offs >= 0x80b3056c and offs <= 0x80b3056f:
		return offs+ 0x55cc

	if offs >= 0x80b30570 and offs <= 0x80b89aaf:
		return offs+ 0x55d0

	if offs >= 0x80b89ac0:
		return offs+ 0x55c0

	return offs


def fix_offs_twn(offs):
	offs = fix_offs_kor(offs)

	if offs >= 0x80000000 and offs <= 0x800b47a0:
		return offs+ 0x0

	if offs >= 0x800b47a4 and offs <= 0x800b47ab:
		return offs+ 0x4

	if offs >= 0x800b47b0 and offs <= 0x800e712f:
		return offs+ 0x0

	if offs >= 0x800e7130 and offs <= 0x800e7133:
		return offs+ 0xc

	if offs >= 0x800e7134 and offs <= 0x800e7137:
		return offs- 0x4

	if offs >= 0x800e7138 and offs <= 0x800e713b:
		return offs+ 0x0

	if offs >= 0x800e713c and offs <= 0x800e714b:
		return offs+ 0x4

	if offs >= 0x800e7150 and offs <= 0x80158c17:
		return offs+ 0x0

	if offs >= 0x80158c18 and offs <= 0x80158dab:
		return offs+ 0x4

	if offs >= 0x80158db0 and offs <= 0x80300647:
		return offs+ 0x0

	if offs >= 0x80302278 and offs <= 0x803097cf:
		return offs- 0x1c30

	if offs >= 0x803097e0 and offs <= 0x803343af:
		return offs- 0x1c40

	if offs >= 0x803343b8 and offs <= 0x8033b15f:
		return offs- 0x1c48

	if offs >= 0x8033b160 and offs <= 0x8035e37f:
		return offs- 0x1c40

	if offs >= 0x8035e380 and offs <= 0x806dffff:
		return offs- 0x1c00

	if offs >= 0x806e0000 and offs <= 0x807a1a33:
		return offs+ 0x0

	if offs >= 0x807a1a50 and offs <= 0x807a1a9b:
		return offs- 0x1c

	if offs >= 0x807a1aac and offs <= 0x807a1adf:
		return offs- 0x2c

	if offs >= 0x807a1ae0 and offs <= 0x807a229b:
		return offs- 0x20

	if offs >= 0x807a22ac and offs <= 0x807a2bc3:
		return offs- 0x30

	if offs >= 0x807a2bd4 and offs <= 0x807a2c13:
		return offs- 0x40

	if offs >= 0x807a2c28 and offs <= 0x807a2c9f:
		return offs- 0x54

	if offs >= 0x807a2ca0 and offs <= 0x807a846f:
		return offs- 0x50

	if offs >= 0x807a8470 and offs <= 0x807a8473:
		return offs- 0x48

	if offs >= 0x807a8474 and offs <= 0x807a8477:
		return offs- 0x54

	if offs >= 0x807a8478 and offs <= 0x807a857b:
		return offs- 0x4c

	if offs >= 0x807a8580 and offs <= 0x807abc23:
		return offs- 0x50

	if offs >= 0x807abc24 and offs <= 0x807abc27:
		return offs- 0x48

	if offs >= 0x807abc28 and offs <= 0x807abc2b:
		return offs- 0x54

	if offs >= 0x807abc2c and offs <= 0x807abcdb:
		return offs- 0x4c

	if offs >= 0x807abce0 and offs <= 0x8094d377:
		return offs- 0x50

	if offs >= 0x8094d384 and offs <= 0x8094d66b:
		return offs- 0x5c

	if offs >= 0x8094d670 and offs <= 0x8094f44b:
		return offs- 0x60

	if offs >= 0x8094f450 and offs <= 0x8094f4d7:
		return offs- 0x64

	if offs >= 0x8094f4dc and offs <= 0x8094f507:
		return offs- 0x68

	if offs >= 0x8094f50c and offs <= 0x8094f54f:
		return offs- 0x6c

	if offs >= 0x8094f550 and offs <= 0x8094f68b:
		return offs- 0x68

	if offs >= 0x8094f69c and offs <= 0x8095117f:
		return offs- 0x78

	if offs >= 0x80951188 and offs <= 0x809511d3:
		return offs- 0x80

	if offs >= 0x809511d8 and offs <= 0x809511ff:
		return offs- 0x84

	if offs >= 0x80951200 and offs <= 0x80951227:
		return offs- 0x80

	if offs >= 0x8095122c and offs <= 0x80951277:
		return offs- 0x84

	if offs >= 0x80951278 and offs <= 0x80951b6b:
		return offs- 0x80

	if offs >= 0x80951b74 and offs <= 0x80952683:
		return offs- 0x88

	if offs >= 0x8095268c and offs <= 0x809957df:
		return offs- 0x90

	if offs >= 0x809957e0:
		return offs- 0x80

	return offs


import yaml

original = 'pal'
fix_for = {
	'pal2': fix_offs_pal_v2,
	'ntsc': fix_offs_ntsc_v1,
	'ntsc2': fix_offs_ntsc_v2,
	'jpn': fix_offs_jpn_v1,
	'jpn2': fix_offs_jpn_v2,
	'kor': fix_offs_kor,
	'twn': fix_offs_twn
}

fixmes = {
	'setMatrix__21dPlayerModelHandler_cFPA4_f':
	'_ZN21dPlayerModelHandler_c9setMatrixEPA4_f',

	'SetCameraMtxDirectly__Q34nw4r3g3d6CameraFRA3_A4_Cf':
	'_ZN4nw4r3g3d6Camera20SetCameraMtxDirectlyERA3_A4_Kf',

	'GetCameraMtx__Q34nw4r3g3d6CameraCFPA3_A4_f':
	'_ZKN4nw4r3g3d6Camera12GetCameraMtxPA3_A4_f',

	'getViewMatrix__Q23m3d9scnLeaf_cFPA3_A4_f':
	'_ZN3m3d9scnLeaf_c13getViewMatrixEPA3_A4_f',

	'setDrawMatrix__Q23m3d5mdl_cFPA4_Cf':
	'_ZN3m3d5mdl_c13setDrawMatrixEPA4_Kf',

	'getMatrixForNode__Q23m3d5mdl_cFUiPA4_f':
	'_ZN3m3d5mdl_c16getMatrixForNodeEjPA4_f',
}

def do_mapfile(src, dest, fix_offset, region):
	map = [x.strip() for x in open(src, 'r')]
	new = []

	for line in map:
		if ' = 0x80' in line:
			spos = line.find(' ')
			pos = line.find('0x80')
			name = line[:spos]
			if name.startswith('_Z') and '/*addAnyway*/' not in line:
				continue #already mangled for Itanium
			old_name = name
			if '/*mi*/' not in line:
				f = from_cw(name)
				if f:
					name = mangle(f)
					if 'FIXME' in name:
						try:
							name = fixmes[old_name]
						except KeyError:
							print "FIX ME!"
							print old_name
				# print 'OUT: ' + name

			offs = int(line[pos:pos+10], 0)

			if '/*pal*/' not in line and '/*pal2*/' not in line and '/*ntsc*/' not in line and '/*ntsc2*/' not in line and '/*jpn*/' not in line and '/*jpn2*/' not in line and '/*kor*/' not in line and '/*twn*/' not in line and '/*chn*/' not in line:
				offs = fix_offset(offs)
			else: # Okay I KNOW this looks terrible
				if not (('/*pal*/' in line and region == 0) or ('/*pal2*/' in line and region == 1) or ('/*ntsc*/' in line and region == 2) or ('/*ntsc2*/' in line and region == 3) or ('/*jpn*/' in line and region == 4) or ('/*jpn2*/' in line and region == 5) or ('/*kor*/' in line and region == 6) or ('/*twn*/' in line and region == 7) or ('/*chn*/' in line and region == 8)):
					continue

			
			after = line[pos+10:]
			line = name + ' = ' + make_hex_offset(offs) + after
			if name != old_name:
				new.append(line + '\n')
				line = old_name + ' = ' + make_hex_offset(offs) + after

		new.append(line + '\n')

	open(dest, 'w').writelines(new)


def work_on_hook(hook, id, func):
	
	try:
		t = hook['type']

		if t == 'patch':
			error = 'missing addr'
			
			hook['addr_%s' % id] = func(hook['addr_%s' % original])

		elif t == 'write_addr':
			error = 'missing addr'
			
			hook['addr_%s' % id] = func(hook['addr_%s' % original])
			hook['data_%s' % id] = func(hook['data_%s' % original])

		elif t == 'branch_insn' or t == 'add_func_pointer':
			error = 'missing src_addr'


			try:
				vh = hook['src_addr_%s' % id]
			except:
				vh = 0

			if vh != 0xDEADF00D:
				area = hook['src_addr_%s' % original]
				# hook['src_addr_%s' % id] = func(hook['src_addr_%s' % original])

				if isinstance(area, list):
					new_area = []
					for index, item in enumerate(area):
						new_area.append(func(item))
				else:
					new_area = func(hook['src_addr_%s' % original])

				if not ('src_addr_%s' % id) in hook:
					hook['src_addr_%s' % id] = new_area
			else:
				hook['src_addr_%s' % id] = vh

			if 'target_func_%s' % original in hook:
				error = 'missing target_func'

				hook['target_func_%s' % id] = func(hook['target_func_%s' % original])

		elif t == 'nop_insn':
			error = 'missing area'

			area = hook['area_%s' % original]
			if isinstance(area, list):
				start = func(area[0])
				new_area = [start, start + (area[1] - area[0])]
			else:
				new_area = func(area)

			hook['area_%s' % id] = new_area

	except:
		print 'Key Error %s for %s (%s) for %s' % (error, hook['name'], hook['type'], id)

	#if hook['name'] == 'WM_onCreate': print hook


def do_module(src, dest):
	m = yaml.safe_load(open(src, 'r').read())

	if 'hooks' in m:
		for id, func in fix_for.iteritems():
			for hook in m['hooks']:
				work_on_hook(hook, id, func)

	open(dest, 'w').write(yaml.dump(m))


def do_project(f, already_done):
	proj = yaml.safe_load(open(f, 'r').read())

	for m in proj['modules']:
		if m not in already_done:
			already_done.add(m)
			do_module(m.replace('processed/', ''), m)


def main():
	do_mapfile('kamek_base.x', 'kamek_pal.x', fix_offs_pal_v1, 0)
	do_mapfile('kamek_base.x', 'kamek_pal2.x', fix_offs_pal_v2, 1)
	do_mapfile('kamek_base.x', 'kamek_ntsc.x', fix_offs_ntsc_v1, 2)
	do_mapfile('kamek_base.x', 'kamek_ntsc2.x', fix_offs_ntsc_v2, 3)
	do_mapfile('kamek_base.x', 'kamek_jpn.x', fix_offs_jpn_v1, 4)
	do_mapfile('kamek_base.x', 'kamek_jpn2.x', fix_offs_jpn_v2, 5)
	do_mapfile('kamek_base.x', 'kamek_kor.x', fix_offs_kor, 6)
	do_mapfile('kamek_base.x', 'kamek_twn.x', fix_offs_twn, 7)

	already_done = set()
	do_project('NewerProjectKP.yaml', already_done)

if __name__ == '__main__':
	main()

