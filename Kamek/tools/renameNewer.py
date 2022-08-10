import os
import sys

output=''

def parse_cmd_options():
	global output
	for arg in sys.argv:
		if arg.startswith('--output='):
			output = arg[9:]
			

def renaming():
	try:
		if os.path.exists('%s/SystemEU_1.bin' % (output)):
			os.remove('%s/SystemEU_1.bin' % (output))
			os.remove('%s/DLCodeEU_1.bin' % (output))
			os.remove('%s/DLRelocsEU_1.bin' % (output))
			os.remove('%s/SystemEU_2.bin' % (output))
			os.remove('%s/DLCodeEU_2.bin' % (output))
			os.remove('%s/DLRelocsEU_2.bin' % (output))

			os.remove('%s/SystemUS_1.bin' % (output))
			os.remove('%s/DLCodeUS_1.bin' % (output))
			os.remove('%s/DLRelocsUS_1.bin' % (output))
			os.remove('%s/SystemUS_2.bin' % (output))
			os.remove('%s/DLCodeUS_2.bin' % (output))
			os.remove('%s/DLRelocsUS_2.bin' % (output))

			os.remove('%s/SystemJP_1.bin' % (output))
			os.remove('%s/DLCodeJP_1.bin' % (output))
			os.remove('%s/DLRelocsJP_1.bin' % (output))
			os.remove('%s/SystemJP_2.bin' % (output))
			os.remove('%s/DLCodeJP_2.bin' % (output))
			os.remove('%s/DLRelocsJP_2.bin' % (output))

			os.remove('%s/SystemKR_3.bin' % (output))
			os.remove('%s/DLCodeKR_3.bin' % (output))
			os.remove('%s/DLRelocsKR_3.bin' % (output))
			os.remove('%s/SystemTW_4.bin' % (output))
			os.remove('%s/DLCodeTW_4.bin' % (output))
			os.remove('%s/DLRelocsTW_4.bin' % (output))
	except:
		print("An exception occurred")

	try:
		os.rename('NewerASM/n_pal_loader.bin', '%s/SystemEU_1.bin' % (output))
		os.rename('NewerASM/n_pal_dlcode.bin', '%s/DLCodeEU_1.bin' % (output))
		os.rename('NewerASM/n_pal_dlrelocs.bin', '%s/DLRelocsEU_1.bin' % (output))
		os.rename('NewerASM/n_pal2_loader.bin', '%s/SystemEU_2.bin' % (output))
		os.rename('NewerASM/n_pal2_dlcode.bin', '%s/DLCodeEU_2.bin' % (output))
		os.rename('NewerASM/n_pal2_dlrelocs.bin', '%s/DLRelocsEU_2.bin' % (output))

		os.rename('NewerASM/n_ntsc_loader.bin', '%s/SystemUS_1.bin' % (output))
		os.rename('NewerASM/n_ntsc_dlcode.bin', '%s/DLCodeUS_1.bin' % (output))
		os.rename('NewerASM/n_ntsc_dlrelocs.bin', '%s/DLRelocsUS_1.bin' % (output))
		os.rename('NewerASM/n_ntsc2_loader.bin', '%s/SystemUS_2.bin' % (output))
		os.rename('NewerASM/n_ntsc2_dlcode.bin', '%s/DLCodeUS_2.bin' % (output))
		os.rename('NewerASM/n_ntsc2_dlrelocs.bin', '%s/DLRelocsUS_2.bin' % (output))

		os.rename('NewerASM/n_jpn_loader.bin', '%s/SystemJP_1.bin' % (output))
		os.rename('NewerASM/n_jpn_dlcode.bin', '%s/DLCodeJP_1.bin' % (output))
		os.rename('NewerASM/n_jpn_dlrelocs.bin', '%s/DLRelocsJP_1.bin' % (output))
		os.rename('NewerASM/n_jpn2_loader.bin', '%s/SystemJP_2.bin' % (output))
		os.rename('NewerASM/n_jpn2_dlcode.bin', '%s/DLCodeJP_2.bin' % (output))
		os.rename('NewerASM/n_jpn2_dlrelocs.bin', '%s/DLRelocsJP_2.bin' % (output))

		os.rename('NewerASM/n_kor_loader.bin', '%s/SystemKR_3.bin' % (output))
		os.rename('NewerASM/n_kor_dlcode.bin', '%s/DLCodeKR_3.bin' % (output))
		os.rename('NewerASM/n_kor_dlrelocs.bin', '%s/DLRelocsKR_3.bin' % (output))
		os.rename('NewerASM/n_twn_loader.bin', '%s/SystemTW_4.bin' % (output))
		os.rename('NewerASM/n_twn_dlcode.bin', '%s/DLCodeTW_4.bin' % (output))
		os.rename('NewerASM/n_twn_dlrelocs.bin', '%s/DLRelocsTW_4.bin' % (output))

		print('* Files Renamed and placed in %s' % (output))
	except:
		print("An exception occurred")

parse_cmd_options()
renaming()