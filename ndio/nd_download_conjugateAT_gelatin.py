import ndio
import scipy.io as io
import os
import ndio.remote.neurodata as neurodata


nd = neurodata(hostname='synaptomes.neurodata.io')
volumeList = ['collman14v2'];
#'Ex2R18C1', 'Ex2R18C2', 'Ex3R43C1', 'Ex3R43C2', 'Ex3R43C3', 'Ex6R15C1', 'Ex6R15C2', 'Ex10R55','Ex12R75', 'Ex12R76', 'Ex13R51',

#
#baseStr = "/data/anish/Synaptome/kristina15/rawVolumes/";
baseStr = "/Users/anish/Documents/Connectome/Synaptome-Duke/";

folderStrBoolean = os.path.isdir(baseStr);
if (folderStrBoolean == False):
	os.mkdir(baseStr)
	print "Folder Created"

for token in volumeList:
	print token
	channels = nd.get_channels(token)
	x_stop, y_stop, z_stop = nd.get_image_size(token, resolution=0)
	print x_stop, y_stop, z_stop


	# See if directory exists
	folderStr = baseStr + token + os.path.sep;
	folderStrBoolean = os.path.isdir(folderStr);
	if (folderStrBoolean == False):
		os.mkdir(folderStr)
		print "Folder Created"

	print "Folder check completed"
	tokenList = channels.keys();

	z_pt = z_stop / 3;

	query = {
	    'token': token,
	    'channel': 'PSD95_1',
	    'x_start': 0,
	    'x_stop': x_stop,
	    'y_start': 0,
	    'y_stop': y_stop,
	    'z_start': 0,
	    'z_stop': z_pt,
	    'resolution': 0
	}

	for x in xrange(0, len(tokenList)):

	  c = tokenList[x]
	  print "{}".format(c),
	  print ""

	  query['channel'] = c
	  channelName = "{}".format(c)
	  print x;
	  fullFileName = folderStr + channelName + "_p1";
	  cutout = nd.get_cutout(**query)
	  io.savemat(fullFileName,{channelName:cutout})
	  print "file saved"

	zpt2 = z_pt * 2;
	query['z_start'] = z_pt;
	query['z_stop'] = zpt2;

	for x in xrange(0, len(tokenList)):

	  c = tokenList[x]
	  print "{}".format(c),
	  print ""

	  query['channel'] = c
	  channelName = "{}".format(c)
	  print x;
	  fullFileName = folderStr + channelName + "_p2";
	  cutout = nd.get_cutout(**query)
	  io.savemat(fullFileName,{channelName:cutout})
	  print "file saved"

	query['z_start'] = zpt2;
	query['z_stop'] = z_stop;

	for x in xrange(0, len(tokenList)):

	  c = tokenList[x]
	  print "{}".format(c),
	  print ""

	  query['channel'] = c
	  channelName = "{}".format(c)
	  print x;
	  fullFileName = folderStr + channelName + "_p3";
	  cutout = nd.get_cutout(**query)
	  io.savemat(fullFileName,{channelName:cutout})
	  print "file saved"



	print("download completed")
