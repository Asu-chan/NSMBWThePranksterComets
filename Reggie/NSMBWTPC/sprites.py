# New Super Mario Bros. Wii: The Prankster Comets
# Custom Reggie! Next sprites.py Module
# By Asu-chan


from PyQt5 import QtCore, QtGui
Qt = QtCore.Qt

import spritelib as SLib
import sprites_common as common

ImageCache = SLib.ImageCache

################################################################################
################################################################################
################################################################################

# TPC-specific base classes
class SpriteImage_PurpleCoin(SLib.SpriteImage_Static):  # 239
    @staticmethod
    def loadImages():
        if 'PurpleCoin' in ImageCache: return
        ImageCache['PurpleCoin'] = SLib.GetImg('purplecoin.png')

    def dataChanged(self):
        self.image = ImageCache['PurpleCoin']

        self.width = self.image.width() 
        self.height = self.image.height()
        self.offset = (0, 0)

        super().dataChanged()



class SpriteImage_PlusMinusClock(SLib.SpriteImage_StaticMultiple):  # 244
    def __init__(self, parent):
        super().__init__(parent, 1.5)

    @staticmethod
    def loadImages():
        if 'PlusClock1' in ImageCache: return
        ImageCache['PlusClock0'] = SLib.GetImg('clockplus1.png')
        ImageCache['PlusClock1'] = SLib.GetImg('clockplus2.png')
        ImageCache['PlusClock2'] = SLib.GetImg('clockminus1.png')
        ImageCache['PlusClock3'] = SLib.GetImg('clockminus2.png')

    def dataChanged(self):
        isSubtracting = (self.parent.spritedata[3] & 1) * 2
        timeValue = int(self.parent.spritedata[4] >= 60)

        self.image = ImageCache['PlusClock%d' % (isSubtracting + timeValue)]

        self.width = self.image.width()
        self.height = self.image.height()
        self.offset = (-19, -21)

        super().dataChanged()



class SpriteImage_PowerStar(SLib.SpriteImage_Static):  # 239
    @staticmethod
    def loadImages():
        if 'PowerStar' in ImageCache: return
        ImageCache['PowerStar'] = SLib.GetImg('powerstar.png')

    def dataChanged(self):
        self.image = ImageCache['PowerStar']

        self.width = self.image.width() 
        self.height = self.image.height()
        self.offset = (-16, -15)

        super().dataChanged()



class SpriteImage_Flipblock(SLib.SpriteImage_Static):  # 483
    def __init__(self, parent):
        super().__init__(
            parent,
            1.5,
            ImageCache['Flipblock'],
        )

    @staticmethod
    def loadImages():
        SLib.loadIfNotInImageCache('Flipblock', 'flipblock.png')



class SpriteImage_ActorSpawner(SLib.SpriteImage_Static):  # 88
    def __init__(self, parent):
        super().__init__(
            parent,
            1.5,
            ImageCache['ActorSpawner'],
            (8, 0),
        )

    @staticmethod
    def loadImages():
        SLib.loadIfNotInImageCache('ActorSpawner', 'ActorSpawner.png')



class SpriteImage_TileEventNewer(common.SpriteImage_TileEvent):  # 191
    def __init__(self, parent):
        super().__init__(parent)
        self.notAllowedTypes = (2, 5, 7, 13, 15)

    def getTileFromType(self, type_):
        if type_ == 0:
            return SLib.GetTile(55)

        if type_ == 1:
            return SLib.GetTile(48)

        if type_ == 3:
            return SLib.GetTile(52)

        if type_ == 4:
            return SLib.GetTile(51)

        if type_ == 6:
            return SLib.GetTile(45)

        if type_ in [8, 9, 10, 11]:
            row = self.parent.spritedata[2] & 0xF
            col = self.parent.spritedata[3] >> 4

            tilenum = 256 * (type_ - 8)
            tilenum += row * 16 + col

            return SLib.GetTile(tilenum)

        if type_ == 12:
            return SLib.GetTile(256 * 3 + 67)

        if type_ == 14:
            return SLib.GetTile(256)

        return None


class SpriteImage_Block(SLib.SpriteImage):  # 207, 208, 209, 221, 255, 256, 402, 403, 422, 423
    def __init__(self, parent, scale=1.5):
        super().__init__(parent, scale)
        self.spritebox.shown = False

        self.tilenum = 1315
        self.contentsNybble = 5
        self.contentsOverride = None
        self.eightIsMushroom = False
        self.twelveIsMushroom = False
        self.rotates = False

    def dataChanged(self):
        super().dataChanged()

        # SET CONTENTS
        # In the blocks.png file:
        # 0 = Empty, 1 = Coin, 2 = Mushroom, 3 = Fire Flower, 4 = Propeller, 5 = Penguin Suit,
        # 6 = Mini Shroom, 7 = Star, 8 = Continuous Star, 9 = Yoshi Egg, 10 = 10 Coins,
        # 11 = 1-up, 12 = Vine, 13 = Spring, 14 = Shroom/Coin, 15 = Ice Flower, 16 = Toad, 17 = Hammer

        if self.contentsOverride is not None:
            contents = self.contentsOverride
        else:
            contents = self.parent.spritedata[self.contentsNybble] & 0xF

        if contents == 2:  # Hammer
            contents = 17

        if contents == 12 and self.twelveIsMushroom:
            contents = 2  # 12 is a mushroom on some types
        if contents == 8 and self.eightIsMushroom:
            contents = 2  # same as above, but for type 8

        self.image = ImageCache['BlockContents'][contents]

        # SET UP ROTATION
        if self.rotates:
            transform = QtGui.QTransform()
            transform.translate(12, 12)

            angle = (self.parent.spritedata[4] & 0xF0) >> 4
            leftTilt = self.parent.spritedata[3] & 1

            angle *= (45.0 / 16.0)

            if leftTilt == 0:
                transform.rotate(angle)
            else:
                transform.rotate(360.0 - angle)

            transform.translate(-12, -12)
            self.parent.setTransform(transform)

    def paint(self, painter):
        super().paint(painter)

        painter.setRenderHint(QtGui.QPainter.Antialiasing)
        if self.tilenum < len(SLib.Tiles):
            painter.drawPixmap(0, 0, SLib.GetTile(self.tilenum))
        painter.drawPixmap(0, 0, self.image)


class SpriteImage_QBlock(SpriteImage_Block):  # 207
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 49


class SpriteImage_QBlockUnused(SpriteImage_Block):  # 208
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 49
        self.eightIsMushroom = True
        self.twelveIsMushroom = True


class SpriteImage_BrickBlock(SpriteImage_Block):  # 209
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 48


class SpriteImage_InvisibleBlock(SpriteImage_Block):  # 221
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.eightIsMushroom = True
        self.tilenum = 0x200 * 4


class SpriteImage_RotatingQBlock(SpriteImage_Block):  # 255
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 49
        self.contentsNybble = 4
        self.twelveIsMushroom = True
        self.rotates = True


class SpriteImage_RotatingBrickBlock(SpriteImage_Block):  # 256
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 48
        self.contentsNybble = 4
        self.twelveIsMushroom = True
        self.rotates = True


class SpriteImage_LineQBlock(SpriteImage_Block):  # 402
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 49
        self.twelveIsMushroom = True


class SpriteImage_LineBrickBlock(SpriteImage_Block):  # 403
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.tilenum = 48


class SpriteImage_FlyingQBlock(SLib.SpriteImage):  # 175
    def __init__(self, parent):
        super().__init__(parent, 1.5)
        self.spritebox.shown = False

        self.dimensions = (-12, -16, 42, 32)

    @staticmethod
    def loadImages():
        SLib.loadIfNotInImageCache('FlyingQBlock', 'flying_qblock.png')

    def paint(self, painter):
        super().paint(painter)

        theme = self.parent.spritedata[4] >> 4
        content = self.parent.spritedata[5] & 0xF

        if theme > 3:
            theme = 0

        if content == 2:
            content = 17
        elif content in (8, 9, 10, 12, 13, 14):
            content = 0

        painter.drawPixmap(0, 0, ImageCache['FlyingQBlock'])
        painter.drawPixmap(18, 23, ImageCache['Blocks'][theme])
        painter.drawPixmap(18, 23, ImageCache['BlockContents'][content])


ImageClasses = {
    239: SpriteImage_PurpleCoin,
    244: SpriteImage_PlusMinusClock,
    283: SpriteImage_PowerStar,
    483: SpriteImage_Flipblock,
    485: SpriteImage_ActorSpawner,
    191: SpriteImage_TileEventNewer,
    207: SpriteImage_QBlock,
    208: SpriteImage_QBlockUnused,
    209: SpriteImage_BrickBlock,
    221: SpriteImage_InvisibleBlock,
    255: SpriteImage_RotatingQBlock,
    256: SpriteImage_RotatingBrickBlock,
    402: SpriteImage_LineQBlock,
    403: SpriteImage_LineBrickBlock,
    175: SpriteImage_FlyingQBlock,
}
