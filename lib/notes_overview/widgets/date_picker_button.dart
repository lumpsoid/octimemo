import 'package:flutter/material.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<NotesOverviewViewModel>();
    return ValueListenableBuilder(
      valueListenable: viewModel.filters,
      builder: (context, filters, _) {
        final dateSelected = filters.containsKey(DateFilter);

        final onTap = dateSelected
            ? viewModel.clearDate
            : () async {
                final dateNow = DateTime.now();
                final datePicked = await showDatePicker(
                  context: context,
                  initialDate: dateNow,
                  firstDate: DateTime(2024),
                  lastDate: dateNow,
                );
                if (datePicked == null) {
                  return;
                }
                viewModel.selectDate(datePicked);
              };

        final buttonIcon =
            dateSelected ? Icons.event_busy : Icons.calendar_month;

        return IconButton(
          color: ColorScheme.of(context).onSurfaceVariant,
          icon: Icon(buttonIcon),
          padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
          onPressed: onTap,
        );
      },
    );
  }
}
