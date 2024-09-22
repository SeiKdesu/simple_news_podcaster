import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

class NEWSAIPodcast extends StatelessWidget {
  const NEWSAIPodcast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          _buildHeader(),
          _buildNewsHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3300.0, vertical: 900.0),
            child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: TextButton.icon(
                onPressed: () {},
                label: Icon(Icons.home),
              ),
            ),
          ),
          _PodcastCard(
            offset: Offset(27.0, 741.0),
            title: 'Haruka',
            description: '難しいニュースを、どなたでも\n理解できるように優しくお伝えします。',
            imagePath: 'assets/images/haruka.png',
            backgroundColor: const Color(0xffe7ffd6),
            audioPath: 'assets/audio/haruka.wav',
          ),
          _PodcastCard(
            offset: Offset(27.0, 582.0),
            title: 'Tarou',
            description: '難しいニュースを、少し噛み砕いて\nお伝えします。',
            imagePath: 'assets/images/tarou.png',
            backgroundColor: const Color(0xffd6f4ff),
            audioPath: 'assets/audio/tarou.wav',
          ),
          _PodcastCard(
            offset: Offset(27.0, 423.0),
            title: 'Sakura',
            description: 'ビジネスパーソンのあなたに、\n本日のピックアップニュースをお伝えします。',
            imagePath: 'assets/images/sakura.png',
            backgroundColor: const Color(0xffffd6d6),
            audioPath: 'assets/audio/sakura.wav',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Transform.translate(
      offset: const Offset(118.0, 71.0),
      child: Text(
        'NEWS AI Podcast',
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 24,
          color: const Color(0xff707070),
          fontWeight: FontWeight.w700,
        ),
        softWrap: false,
      ),
    );
  }

  Widget _buildNewsHeader() {
    return Transform.translate(
      offset: Offset(27.0, 129.0),
      child: SizedBox(
        width: 376.0,
        height: 262.0,
        child: Stack(
          children: <Widget>[
            _buildCardContainer(),
            Transform.translate(
              offset: Offset(7.0, 30.0),
              child: Text(
                ' Today’s pick up news                                        ・ウォラーＦＲＢ理事、大幅利下げを..   ・スリーマイル原発が復活へ、AI需要.. ・円売り継続、一時144円49銭 S&P50.. ・自民総裁選、小泉氏一歩リードか-..    ・顧客情報巡り日本郵便で法令違反があったと認識－かんぽ生命',
                maxLines: 6, // 最大2行
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 20,
                  color: const Color(0xff707070),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer() {
    return Container(
      width: 376.0,
      height: 300.0,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(23.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}

class _PodcastCard extends StatefulWidget {
  final Offset offset;
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final String audioPath;

  const _PodcastCard({
    Key? key,
    required this.offset,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.audioPath,
  }) : super(key: key);

  @override
  __PodcastCardState createState() => __PodcastCardState();
}

class __PodcastCardState extends State<_PodcastCard> {
  bool _isPressed = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.offset,
      child: InkWell(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          _playAudio();
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        highlightColor: const Color.fromARGB(0, 255, 255, 255),
        splashColor: const Color.fromARGB(0, 255, 255, 255),
        child: Container(
          width: 376.0,
          height: 141.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(23.0),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0x40000000),
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
            ),
            transform: _isPressed
                ? Matrix4.translationValues(0, 5, 0)
                : Matrix4.identity(),
            child: Stack(
              children: <Widget>[
                _buildCircleBackground(widget.backgroundColor),
                _buildIcon(),
                _buildTitle(widget.title),
                _buildDescription(widget.description),
                _buildImage(widget.imagePath),
                _buildPlayPauseButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playAudio() async {
    if (_isPlaying) {
      try {
        await _audioPlayer.stop();
        _isPlaying = false;
        print("Audio stopped.");
      } catch (e) {
        print("Error stopping audio: $e");
      }
    } else {
      try {
        print("Attempting to play audio...");
        _isPlaying = true;
        await _audioPlayer.setSource(AssetSource(widget.audioPath));
        print("Audio source set.");
        await _audioPlayer.resume();
        print("Audio playback started.");

        _audioPlayer.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
          });
          print("Audio playback completed.");
        });
      } catch (e) {
        _isPlaying = false;
        print("Error playing audio: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('音声の再生に失敗しました。もう一度お試しください。'),
          ),
        );
      }
    }
  }

  Widget _buildPlayPauseButton() { //再生ボタン
    return Positioned(
      right: 12.0,
      top: 42.0,
      child: Container(
        width: 50.0, // 幅を設定
        height: 50.0, // 高さを設定
        decoration: BoxDecoration(
          color: const Color(0xff707070), // 背景色を設定
          borderRadius: BorderRadius.circular(25.0), // 円形にするための設定
        ),
        child: IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: const Color(0xffffffff), // ボタンのアイコン色
            size: 24.0, // アイコンサイズを調整
          ),
          onPressed: () {
            _playAudio();
          },
        ),
      ),
    );
  }

  Widget _buildCircleBackground(Color color) {
    return Transform.translate(
      offset: Offset(11.0, 11.0),
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9999.0),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Transform.translate(
      offset: Offset(320.0, 50.0),
      child: SizedBox(
        width: 42.0,
        height: 42.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: const Color(0xff707070),
                borderRadius: BorderRadius.circular(9999.0),
              ),
            ),
            Transform.translate(
              offset: Offset(15.2, 10.0),
              child: SizedBox(
                width: 17.0,
                height: 22.0,
                child: SvgPicture.string(
                  _svg_sitx25,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Transform.translate(
      offset: Offset(142.0, 48.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 20,
          color: const Color(0xff707070),
          fontWeight: FontWeight.w700,
        ),
        softWrap: false,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Transform.translate(
      offset: Offset(143.0, 74.0),
      child: Text(
        description,
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 8,
          color: const Color(0xff707070),
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
        softWrap: false,
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return Transform.translate(
      offset: Offset(33.0, 25.0),
      child: Container(
        width: 76.0,
        height: 106.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

const String _svg_sitx25 =
    '<svg viewBox="15.2 10.0 17.4 22.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 32.62, 10.0)" d="M 11.00000095367432 0 L 22.00000190734863 17.44844436645508 L 0 17.44844436645508 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
