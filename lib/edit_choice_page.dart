import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


List<AssetImage> _editChoiceButtons = [
  AssetImage('assets/buttons_images/head_left_right.png'),
  AssetImage('assets/buttons_images/head_up_down.png'),
  AssetImage('assets/buttons_images/head_old_young.png'),
  AssetImage('assets/buttons_images/head_expression.png'),
  AssetImage('assets/buttons_images/head_male_female.png'),
  AssetImage('assets/buttons_images/head_glasses.png'),
  AssetImage('assets/buttons_images/head_beard.png'),
  AssetImage('assets/buttons_images/head_bald_hairy.png'),
  AssetImage('assets/buttons_images/save.png'),
  AssetImage('assets/buttons_images/share.png'),
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white12
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Slider(
                          value: _sliderValue,
                          activeColor: Colors.white60,
                          inactiveColor: Colors.white12,
                          onChanged: (newRatio){
                            setState(() {
                              _sliderValue = newRatio;
                            });
                          },
                          min: 0.0,
                          max: 1.0
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                              children: [
                                TextButton(
                                  onPressed: () => _update(0),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => setState(() {
                                    _sliderValue = 0.0;
                                  }),
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _update(0),
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white60,
                                    ),
                                  ),
                                )
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
    return Center(
      child: Container(
        // height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white12
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(80),
                children: [
                  TableRow(
                    children: [
                      TextButton(
                        onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[0])
                      ),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[1])
                      ),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[2])
                      ),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[3])
                      )
                      ]
                  ),
                  TableRow(
                    children: [
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[4])
                      ),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[5])
                      ),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[6])
                      ),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[7])
                      ),
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
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[8])),
                      TextButton(
                          onPressed: () => update(1),
                          child: Image(image: _editChoiceButtons[9])),
                  ]
                )
              ],
            ),
          )
          ],
        ),
      ),
    );
  }
}