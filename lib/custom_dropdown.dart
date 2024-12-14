import 'package:flutter/material.dart';

typedef ShowItemPropertyInDropDown<T> = String Function(T item);

class CustomDropdownField<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final ShowItemPropertyInDropDown<T>? itemAsString;
  final Color? dropDownColor;
  const CustomDropdownField(
      {super.key,
      required this.items,
      this.itemAsString,
      this.selectedItem,
      this.dropDownColor});

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  OverlayEntry? entry;
  final layerLink = LayerLink();
  FocusNode node = FocusNode();
  TextEditingController txt = TextEditingController();
  T? selectedItem;
  bool overlayShown = false;
  int tapCounter = 0;

  @override
  void dispose() {
    txt.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedItem != null) {
        txt.text = widget.itemAsString != null
            ? widget.itemAsString!(widget.selectedItem as T)
            : widget.selectedItem.toString();
        selectedItem = widget.selectedItem;
      }
    });

    // node.addListener(() {
    //   if (node.hasFocus) {
    //     showOverlay();
    //   } else {
    //     hideOverlay();
    //   }
    // });
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    const overlayHeight = 200.0;
    final screenHeight = MediaQuery.of(context).size.height;
    final widgetPosition = renderBox.localToGlobal(Offset.zero);
    bool showAbove =
        (screenHeight - widgetPosition.dy - size.height) < overlayHeight;
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: showAbove
                  ? const Offset(0, -overlayHeight)
                  : Offset(0, size.height),
              child: buildOverlay()),
        );
      },
    );
    if (entry != null) {
      overlay.insert(entry!);
    }
  }

  Widget buildOverlay() {
    return TapRegion(
      onTapOutside: (event) {
        hideOverlay();
        overlayShown = false;
      },
      child: Material(
        elevation: 8,
        child: Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: widget.dropDownColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ListView.builder(
            // padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              T item = widget.items[index];
              return Row(
                children: [
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        onValSelected(item);
                      },
                      title: Text(widget.itemAsString != null
                          ? widget.itemAsString!(item)
                          : item.toString()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onValSelected(item),
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid)),
                      child: selectedItem == item
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 15,
                            )
                          : null,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void onValSelected(item) {
    selectedItem = item;
    txt.text = widget.itemAsString != null
        ? widget.itemAsString!(item)
        : item.toString();

    node.unfocus();
    hideOverlay();
    overlayShown = false;
  }

  hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        onTap: () {
          tapCounter++;
          if (tapCounter % 2 == 0) {
            overlayShown = false;
            hideOverlay();
            return;
          }
          if (overlayShown == false) {
            // node.requestFocus();
            showOverlay();
            overlayShown = true;
          }
        },
        child: AbsorbPointer(
          child: SizedBox(
            height: 40,
            width: MediaQuery.sizeOf(context).width * 0.40,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    focusNode: node,
                    controller: txt,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Select",
                        hintStyle: TextStyle(color: Colors.grey),
                        disabledBorder: InputBorder.none),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
