import 'package:flutter/material.dart';

class HoverAdminMenu extends StatefulWidget {
  final Function(String route) onNavigate;

  const HoverAdminMenu({
    super.key,
    required this.onNavigate,
  });

  @override
  State<HoverAdminMenu> createState() => _HoverAdminMenuState();
}

class _HoverAdminMenuState extends State<HoverAdminMenu> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= ADMIN BUTTON =================
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Admin",
              style: TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 5),

          // ================= DROPDOWN =================
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isHovered ? 170 : 0,
            child: isHovered
                ? Container(
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _item("Tasks", "/tasks"),
                        _item("Engineers", "/engineers"),
                        _item("Installations", "/installations"),
                        _item("Complaints", "/complaints"),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String route) {
    return InkWell(
      onTap: () => widget.onNavigate(route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: Text(title),
      ),
    );
  }
}