import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


List<AssetImage> _editChoiceButtons = [
  AssetImage('assets/buttons_images/head_left_right.png'),
  AssetImage('assets/buttons_images/head_up_down.png'),
  AssetImage('assets/buttons_images/head_old_young.png'),
  AssetImage('assets/buttons_images/head_male_female.png'),
  AssetImage('assets/buttons_images/head_glasses.png'),
  AssetImage('assets/buttons_images/head_beard.png'),
  AssetImage('assets/buttons_images/head_bald_hairy.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/save.png'),
  AssetImage('assets/buttons_images/male-female.png'),
];

class EditChoicePage extends StatefulWidget {
  final Image selectedImage;
  EditChoicePage({required this.selectedImage}){
    // print(selectedImage);
  }
  @override
  _EditChoicePage createState() => _EditChoicePage();
}

class _EditChoicePage extends State<EditChoicePage> {
  int _widgetIndex = 0;
  double _sliderValue = 0.0;

  void _update(int idx) {
    setState(() => _widgetIndex = idx);
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    child: PhotoView(
                      imageProvider: widget.selectedImage.image,
                    )
                ),
                ),
            IndexedStack(
              index: _widgetIndex,
                children: <Widget>[
              EditChoice(update: _update),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              Slider(
                                value: _sliderValue,
                                onChanged: (newRatio){
                                  setState(() {
                                    _sliderValue = newRatio;
                                  });
                                },
                                min: 0.0,
                                max: 1.0
                              )
                            ]
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                Text('Cancel'),
                                Text('Reset'),
                                Text('Accept')
                              ]
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]
            ),
          ],
        ),
      ),
    );
  }
}

class EditChoice extends StatelessWidget {
  final ValueChanged<int> update;

  const EditChoice({required this.update,  Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white12
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(80),
              children: [
                TableRow(
                  children: [
                    TextButton(
                      onPressed: () => update(1),
                        child: Image(image: _editChoiceButtons[0])
                    ),
                    Image(image: _editChoiceButtons[1]),
                    Image(image: _editChoiceButtons[2]),
                    Image(image: _editChoiceButtons[3])
                    ]
                ),
                TableRow(
                  children: [
                    Image(image: _editChoiceButtons[4]),
                    Image(image: _editChoiceButtons[5]),
                    Image(image: _editChoiceButtons[6]),
                    Image(image: _editChoiceButtons[7]),
                  ]
                )
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Table(
                defaultColumnWidth: FixedColumnWidth(80),
              children: [
                TableRow(
                  children: [
                    Image(image: _editChoiceButtons[8]),
                    Image(image: _editChoiceButtons[0]),
                ]
              )
            ],
          ),
        )
        ],
      ),
    );
  }
}