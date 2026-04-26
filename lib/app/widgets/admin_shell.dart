import 'package:flutter/material.dart';
import 'package:ondas_web/app/widgets/admin_sidebar.dart';

/// Shared shell for all admin pages.
/// Provides the [Scaffold] and left [AdminSidebar].
/// The [child] is the page content placed in the expanded right area.
class AdminShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const AdminShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(currentRoute: currentRoute),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
