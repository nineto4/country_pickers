import 'package:country_pickers/country.dart';
import 'package:country_pickers/countries.dart';
import 'package:country_pickers/utils/typedefs.dart';
import 'package:flutter/material.dart';
import 'utils/utils.dart';

///Provides a customizable [DropdownButton] for all countries
class CountryPickerDropdown extends StatefulWidget {
  CountryPickerDropdown({
    this.itemFilter,
    this.itemBuilder,
    this.initialValue,
    this.onValuePicked,
  });

  /// Filters the available country list
  final ItemFilter itemFilter;

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and phoneCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final ItemBuilder itemBuilder;

  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in countryList map of countries.dart file.
  final String initialValue;

  ///This function will be called whenever a Country item is selected.
  final ValueChanged<Country> onValuePicked;

  @override
  _CountryPickerDropdownState createState() => _CountryPickerDropdownState();
}

class _CountryPickerDropdownState extends State<CountryPickerDropdown> {
  List<Country> _countries;
  Country _selectedCountry;

  @override
  void initState() {
    _countries =
        countryList.where(widget.itemFilter ?? acceptAllCountries).toList();
    if (widget.initialValue != null) {
      for (int i = 0, n = _countries.length; i < n; i++) {
        if (_countries[i].name.toUpperCase() ==
                widget.initialValue.toUpperCase() ||
            _countries[i].isoCode.toUpperCase() ==
                widget.initialValue.toUpperCase()) {
          _selectedCountry = _countries[i];
          break;
        }
      }
      if (_selectedCountry == null) _selectedCountry = _countries[118];
    } else {
      _selectedCountry = _countries[118];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Country>> items = _countries
        .map((country) => DropdownMenuItem<Country>(
            value: country,
            child: widget.itemBuilder != null
                ? widget.itemBuilder(country)
                : _buildDefaultMenuItem(country)))
        .toList();

    return Row(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            isDense: true,
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
                widget.onValuePicked(value);
              });
            },
            items: items,
            value: _selectedCountry,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultMenuItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("(${country.isoCode}) +${country.phoneCode}"),
      ],
    );
  }
}
